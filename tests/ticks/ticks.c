#include <linux/module.h>
#include <linux/init.h>
#include <linux/sysfs.h>
#include <linux/kobject.h>
#include <linux/kernel.h>

static ssize_t jiffies_show(struct kobject *kobj, struct kobj_attribute *attr,
                            char *buf) {
        return sprintf(buf, "%lu", jiffies);
}

static ssize_t hz_show(struct kobject *kobj, struct kobj_attribute *attr,
                       char *buf) {
        return sprintf(buf, "%u", HZ);
}

static struct kobj_attribute jiffies_attr =
        __ATTR(jiffies, 0444, jiffies_show, NULL);
static struct kobj_attribute hz_attr = __ATTR(hz, 0444, hz_show, NULL);

static struct attribute *ticks_attrs[] = { &jiffies_attr.attr, &hz_attr.attr,
                                           NULL };

static struct attribute_group ticks_grp = { .attrs = ticks_attrs };

static struct kobject *ticks;

static int __init ticks_init(void) {
        int retval;

        ticks = kobject_create_and_add("ticks", NULL);
        if (!ticks)
                return -EEXIST;

        retval = sysfs_create_group(ticks, &ticks_grp);
        if (retval)
                kobject_put(ticks);

        return retval;
}
module_init(ticks_init);

static void __exit ticks_exit(void) {
        sysfs_remove_group(ticks, &ticks_grp);

        kobject_put(ticks);
}
module_exit(ticks_exit);

MODULE_LICENSE("GPL");
