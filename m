From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
Date: Mon, 20 Nov 2017 15:12:49 +0800
Message-ID: <b723b554-3c1b-417b-8b8c-3d75551122f4@huawei.com>
References: <20171117054919.712-1-yi.zhang@huawei.com>
 <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
 <20171117183942.GC5111@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171117183942.GC5111@magnolia>
Sender: fstests-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On 2017/11/18 2:39, Darrick J. Wong Wrote:
> On Fri, Nov 17, 2017 at 07:13:23PM +0200, Amir Goldstein wrote:
>> [adding fstests in CC with full patch inline to collect wisdom from
>> other fs developers]
>>
>> On Fri, Nov 17, 2017 at 7:49 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> Hi,
>>>
>>> Here is the origin version of fsck.overlay utility I mentioned last
>>> week. It scan each underlying directory and check orphan whiteout,
>>> invalid opaque xattr and invalid redirect xattr. We can use it to
>>> check filesystem inconsistency before mount overlayfs to avoid some
>>> unexpected results.
>>
>> Thanks for working on this!
>> It looks like a great start.
>>
>>>
>>> This patch can am to an empty git repository. I have already do basic
>>> test list in 'test' directory. Please do a review give some suggestions.
>>> Thanks a lot.
>>
>> Please consider, instead of writing overlay tests in new repo,
>> to write the tests for xfstests and hook overlay.fsck to _check_test_fs/
>> _check_scratch_fs.
>> See for example very basic index sanity checks I implemented here:
>> https://github.com/amir73il/xfstests/commit/dac4da479e3e85be8f7beec54f384c0a832f74bd
>>
>> It may be useful, if Eryu agrees, to merge the "incubator" version of
>> fsck.overlayfs
>> into xfstests as a helper program until it starts getting packaged and
>> distributed.
>> Please consider this option.
>>
>>>
>>> Thanks,
>>> Yi.
>>>
>>> ---------------------------
>>>
>>> fsck.overlay
>>> ============
>>>
>>> fsck.overlay is used to check and optionally repair underlying
>>> directories of overlay-filesystem.
>>>
>>> Check the following points:
>>>
>>> Whiteouts
>>> ---------
>>>
>>> A whiteout is a character device with 0/0 device number. It is used to
>>> record the removed files or directories, When a whiteout is found in a
>>> directory, there should be at least one directory or file with the same
>>> name in any of the corresponding lower layers. If not exist, the whiteout
>>> will be treated as orphan whiteout and remove.
>>>
>>> Opaque directories
>>> ------------------
>>>
>>> An opaque directory is a directory with "trusted.overlay.opaque" xattr
>>> valued "y". There are two legal situations of making opaque directory: 1)
>>> create directory over whiteout 2) creat directory in merged directory. If an
>>> opaque directory is found, corresponding matching name in lower layers might
>>> exist or parent directory might merged, If not, the opaque xattr will be
>>> treated as invalid and remove.
>>>
>>> Redirect directories
>>> --------------------
>>>
>>> An redirect directory is a directory with "trusted.overlay.redirect"
>>> xattr valued to the path of the original location from the root of the
>>> overlay. It is only used when renaming a directory and "redirect dir"
>>> feature is enabled. If an redirect directory is found, the following
>>> must be met:
>>>
>>> 1) The directory store in redirect xattr should exist in one of lower
>>> layers.
>>> 2) The origin directory should be redirected only once in one layer,
>>> which mean there is only one redirect xattr point to this origin directory in
>>> the specified layer.
>>> 3) A whiteout or an opaque directory with the same name to origin should
>>> exist in the same directory as the redirect directory.
>>>
>>> If not, 1) The redirect xattr is invalid and need to remove 2) One of
>>> the redirect xattr is redundant but not sure which one is, ask user 3)
>>> Create a whiteout device or set opaque xattr to an existing directory if the
>>> parent directory was meregd or remove xattr if not.
>>>
>>> Usage
>>> =====
>>>
>>> 1. Ensure overlay filesystem is not mounted based on directories which
>>> need to check.
>>>
>>> 2. Run fsck.overlay program:
>>>    Usage:
>>>    fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
>>>
>>>    Options:
>>>    -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
>>>                              multiple lower use ':' as separator.
>>>    -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
>>>    -w, --workdir=WORKDIR     specify work directory of overlayfs
>>>    -a, --auto                repair automatically (no questions)
>>
>> Let stick with e2fsck conventions when possible.
>> -a should be -y and we should definitely have -n, because this is
>> how xfstest would run it.
> 
> If it's e2fsck conventions you want, then consider that e2fsck has three
> action options -- -n (fix nothing), -y (fix everything), and -p (fix the
> easy stuff that doesn't require interaction); and -a maps to -p.
> 
> In other words, think about whether or not repairs to overlayfs could
> someday be classified into easy fixes vs. difficult fixes.  Even if that
> never happens, if you're going to mirror e2fsck then you might as well
> mirror the exact options behavior.
> 

Thanks for your suggestion, I will add -n, -y and -p options and distinguish
between -y and -p.

Thanks,
Yi.

> 
>>
>>>    -v, --verbose             print more messages of overlayfs
>>>    -h, --help                display this usage of overlayfs
>>>    -V, --version             display version information
>>>
>>> 3. Exit value:
>>>    0      No errors
>>>    1      Filesystem errors corrected
>>>    2      System should be rebooted
>>>    4      Filesystem errors left uncorrected
>>>    8      Operational error
>>>    16     Usage or syntax error
>>>    32     Checking canceled by user request
>>>    128    Shared-library error
>>>
>>> Todo
>>> ====
>>>
>>> 1. Overlay filesystem mounted check. Prevent fscking when overlay is
>>> online. Now, We cannot distinguish mounted directories if overlayfs was
>>> mounted with relative path.
>>
>> This should be handled by kernel.
>> We now already grab an advisory exclusive I_OVL_INUSE lock on both
>> upperdir and workdir.
>> fsck.overlay can try to open upperdir/workdir with O_EXCL|O_DIRECTORY
>> and kernel should fail this open if overlayfs is holding the  I_OVL_INUSE.
>> Read the man page section on O_EXCL and block device. This is how
>> e2fsck and friends get exclusive access w.r.t mount.
>>
>>> 2. Symbolic link check.
>>> 3. Check origin/impure/nlink xattr.
>>> 4. ...
>>>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>> ---
>>>  Makefile                  |  31 +++
>>>  README.md                 |  88 +++++++++
>>>  check.c                   | 482 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  check.h                   |   7 +
>>>  common.c                  |  95 +++++++++
>>>  common.h                  |  34 ++++
>>>  config.h                  |  22 +++
>>>  fsck.c                    | 179 +++++++++++++++++
>>>  lib.c                     | 197 +++++++++++++++++++
>>>  lib.h                     |  73 +++++++
>>>  mount.c                   | 319 ++++++++++++++++++++++++++++++
>>>  mount.h                   |   8 +
>>>  test/README.md            |  12 ++
>>>  test/auto_test.sh         |  46 +++++
>>>  test/clean.sh             |   6 +
>>>  test/local.config         |  16 ++
>>>  test/src/opaque_test.sh   | 144 ++++++++++++++
>>>  test/src/prepare.sh       |  15 ++
>>>  test/src/redirect_test.sh | 163 ++++++++++++++++
>>>  test/src/whiteout_test.sh |  63 ++++++
>>>  20 files changed, 2000 insertions(+)
>>>  create mode 100644 Makefile
>>>  create mode 100644 README.md
>>>  create mode 100644 check.c
>>>  create mode 100644 check.h
>>>  create mode 100644 common.c
>>>  create mode 100644 common.h
>>>  create mode 100644 config.h
>>>  create mode 100644 fsck.c
>>>  create mode 100644 lib.c
>>>  create mode 100644 lib.h
>>>  create mode 100644 mount.c
>>>  create mode 100644 mount.h
>>>  create mode 100644 test/README.md
>>>  create mode 100755 test/auto_test.sh
>>>  create mode 100755 test/clean.sh
>>>  create mode 100644 test/local.config
>>>  create mode 100755 test/src/opaque_test.sh
>>>  create mode 100755 test/src/prepare.sh
>>>  create mode 100755 test/src/redirect_test.sh
>>>  create mode 100755 test/src/whiteout_test.sh
>>>
>>> diff --git a/Makefile b/Makefile
>>> new file mode 100644
>>> index 0000000..ced5005
>>> --- /dev/null
>>> +++ b/Makefile
>>> @@ -0,0 +1,31 @@
>>> +CFLAGS = -Wall -g
>>> +LFLAGS = -lm
>>> +CC = gcc
>>> +
>>> +all: overlay
>>> +
>>> +overlay: fsck.o common.o lib.o check.o mount.o
>>> +       $(CC) $(LFLAGS) fsck.o common.o lib.o check.o mount.o -o fsck.overlay
>>> +
>>> +fsck.o:
>>> +       $(CC) $(CFLAGS) -c fsck.c
>>> +
>>> +common.o:
>>> +       $(CC) $(CFLAGS) -c common.c
>>> +
>>> +lib.o:
>>> +       $(CC) $(CFLAGS) -c lib.c
>>> +
>>> +check.o:
>>> +       $(CC) $(CFLAGS) -c check.c
>>> +
>>> +mount.o:
>>> +       $(CC) $(CFLAGS) -c mount.c
>>> +
>>> +clean:
>>> +       rm -f *.o fsck.overlay
>>> +       rm -rf bin
>>> +
>>> +install: all
>>> +       mkdir bin
>>> +       cp fsck.overlay bin
>>> diff --git a/README.md b/README.md
>>> new file mode 100644
>>> index 0000000..8de69cd
>>> --- /dev/null
>>> +++ b/README.md
>>> @@ -0,0 +1,88 @@
>>> +fsck.overlay
>>> +============
>>> +
>>> +fsck.overlay is used to check and optionally repair underlying directories
>>> +of overlay-filesystem.
>>> +
>>> +Check the following points:
>>> +
>>> +Whiteouts
>>> +---------
>>> +
>>> +A whiteout is a character device with 0/0 device number. It is used to record
>>> +the removed files or directories, When a whiteout is found in a directory,
>>> +there should be at least one directory or file with the same name in any of the
>>> +corresponding lower layers. If not exist, the whiteout will be treated as orphan
>>> +whiteout and remove.
>>> +
>>> +
>>> +Opaque directories
>>> +------------------
>>> +
>>> +An opaque directory is a directory with "trusted.overlay.opaque" xattr valued
>>> +"y". There are two legal situations of making opaque directory: 1) create
>>> +directory over whiteout 2) creat directory in merged directory. If an opaque
>>> +directory is found, corresponding matching name in lower layers might exist or
>>> +parent directory might merged, If not, the opaque xattr will be treated as
>>> +invalid and remove.
>>> +
>>> +
>>> +Redirect directories
>>> +--------------------
>>> +
>>> +An redirect directory is a directory with "trusted.overlay.redirect" xattr
>>> +valued to the path of the original location from the root of the overlay. It
>>> +is only used when renaming a directory and "redirect dir" feature is enabled.
>>> +If an redirect directory is found, the following must be met:
>>> +
>>> +1) The directory store in redirect xattr should exist in one of lower layers.
>>> +2) The origin directory should be redirected only once in one layer, which mean
>>> +   there is only one redirect xattr point to this origin directory in the
>>> +   specified layer.
>>> +3) A whiteout or an opaque directory with the same name to origin should exist
>>> +   in the same directory as the redirect directory.
>> another redirected upper dir can also be covering the redirect lower target
>>
>>> +
>>> +If not, 1) The redirect xattr is invalid and need to remove 2) One of the
>>> +redirect xattr is redundant but not sure which one is, ask user 3) Create a
>>> +whiteout device or set opaque xattr to an existing directory if the parent
>>> +directory was meregd or remove xattr if not.
>>
>> You can consult origin xattr, decode it and fix redirect accordingly.
>> I have plans to implement this in kernel as well with 'verify_dir' mount option,
>> but maybe is it better to do this with fsck tool.
>> Restoring unset origin xattr, which I also sent a kernel patch for can also be
>> done by fsck as Miklos also suggested.
>>
>>
>>> +
>>> +Usage
>>> +=====
>>> +
>>> +1. Ensure overlay filesystem is not mounted based on directories which need to
>>> +   check.
>>> +
>>> +2. Run fsck.overlay program:
>>> +   Usage:
>>> +   fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
>>> +
>>> +   Options:
>>> +   -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
>>> +                             multiple lower use ':' as separator.
>>> +   -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
>>> +   -w, --workdir=WORKDIR     specify work directory of overlayfs
>>> +   -a, --auto                repair automatically (no questions)
>>> +   -v, --verbose             print more messages of overlayfs
>>> +   -h, --help                display this usage of overlayfs
>>> +   -V, --version             display version information
>>> +
>>> +3. Exit value:
>>> +   0      No errors
>>> +   1      Filesystem errors corrected
>>> +   2      System should be rebooted
>>> +   4      Filesystem errors left uncorrected
>>> +   8      Operational error
>>> +   16     Usage or syntax error
>>> +   32     Checking canceled by user request
>>> +   128    Shared-library error
>>> +
>>> +Todo
>>> +====
>>> +
>>> +1. Overlay filesystem mounted check. Prevent fscking when overlay is
>>> +   online. Now, We cannot distinguish mounted directories if overlayfs was
>>> +   mounted with relative path.
>>> +2. Symbolic link check.
>>> +3. Check origin/impure/nlink xattr.
>>> +4. ...
>>> diff --git a/check.c b/check.c
>>> new file mode 100644
>>> index 0000000..1794501
>>> --- /dev/null
>>> +++ b/check.c
>>> @@ -0,0 +1,482 @@
>>> +/*
>>> + *
>>> + *     Check and fix inconsistency for all underlying layers of overlay
>>> + *
>>> + *     zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
>>
>> I guess you are not obliged to, but it would probably be better for
>> you to assign
>> copyright either to you or to your employer.
>> And choosing a license explicitly is also recommended.
>> IMO it would be best if you could keep at least part of the code
>> under LGPL (or a like) and start with a mini liboverlay that can grow over time
>> and be used by other projects.
>>
>>> + *
>>> + */
>>> +
>>> +#include <stdlib.h>
>>> +#include <stdio.h>
>>> +#include <string.h>
>>> +#include <errno.h>
>>> +#include <unistd.h>
>>> +#include <stdbool.h>
>>> +#include <sys/types.h>
>>> +#include <sys/xattr.h>
>>> +#include <sys/stat.h>
>>> +#include <linux/limits.h>
>>> +
>>> +#include "common.h"
>>> +#include "lib.h"
>>> +#include "check.h"
>>> +
>>> +/* Underlying information */
>>> +struct ovl_lower_check {
>>> +       unsigned int type;      /* check extent type */
>>> +
>>> +       bool exist;
>>> +       char path[PATH_MAX];    /* exist pathname found, only valid if exist */
>>> +       struct stat st;         /* only valid if exist */
>>> +};
>>> +
>>> +/* Redirect information */
>>> +struct ovl_redirect_entry {
>>> +       struct ovl_redirect_entry *next;
>>> +
>>> +       char origin[PATH_MAX];  /* origin directory path */
>>> +
>>> +       char path[PATH_MAX];    /* redirect directory */
>>> +       int dirtype;            /* OVL_UPPER or OVL_LOWER */
>>> +       int dirnum;             /* only valid when dirtype==OVL_LOWER */
>>> +};
>>> +
>>> +/* Whiteout */
>>> +#define WHITEOUT_DEV   0
>>> +#define WHITEOUT_MOD   0
>>> +
>>> +extern char **lowerdir;
>>> +extern char upperdir[];
>>> +extern char workdir[];
>>> +extern unsigned int lower_num;
>>> +extern int flags;
>>> +extern int status;
>>> +
>>> +static inline mode_t file_type(const struct stat *status)
>>> +{
>>> +       return status->st_mode & S_IFMT;
>>> +}
>>> +
>>> +static inline bool is_whiteout(const struct stat *status)
>>> +{
>>> +       return (file_type(status) == S_IFCHR) && (status->st_rdev == WHITEOUT_DEV);
>>> +}
>>> +
>>> +static inline bool is_dir(const struct stat *status)
>>> +{
>>> +       return file_type(status) == S_IFDIR;
>>> +}
>>> +
>>> +static bool is_dir_xattr(const char *pathname, const char *xattrname)
>>> +{
>>> +       char val;
>>> +       ssize_t ret;
>>> +
>>> +       ret = getxattr(pathname, xattrname, &val, 1);
>>> +       if ((ret < 0) && !(errno == ENODATA || errno == ENOTSUP)) {
>>> +               print_err(_("Cannot getxattr %s %s: %s\n"), pathname,
>>> +                           xattrname, strerror(errno));
>>> +               return false;
>>> +       }
>>> +
>>> +       return (ret == 1 && val == 'y') ? true : false;
>>> +}
>>> +
>>> +static inline bool ovl_is_opaque(const char *pathname)
>>> +{
>>> +       return is_dir_xattr(pathname, OVL_OPAQUE_XATTR);
>>> +}
>>> +
>>> +static inline int ovl_remove_opaque(const char *pathname)
>>> +{
>>> +       return remove_xattr(pathname, OVL_OPAQUE_XATTR);
>>> +}
>>> +
>>> +static inline int ovl_set_opaque(const char *pathname)
>>> +{
>>> +       return set_xattr(pathname, OVL_OPAQUE_XATTR, "y", 1);
>>> +}
>>> +
>>> +static int ovl_get_redirect(const char *pathname, size_t dirlen,
>>> +                           size_t filelen, char **redirect)
>>> +{
>>> +       char *buf = NULL;
>>> +       ssize_t ret;
>>> +
>>> +       ret = get_xattr(pathname, OVL_REDIRECT_XATTR, &buf, NULL);
>>> +       if (ret <= 0 || !buf)
>>> +               return ret;
>>> +
>>> +       if (buf[0] != '/') {
>>> +               size_t baselen = strlen(pathname)-filelen-dirlen;
>>> +
>>> +               buf = srealloc(buf, ret + baselen + 1);
>>> +               memmove(buf + baselen, buf, ret);
>>> +               memcpy(buf, pathname+dirlen, baselen);
>>> +               buf[ret + baselen] = '\0';
>>> +       }
>>> +
>>> +       *redirect = buf;
>>> +       return 0;
>>> +}
>>> +
>>> +static inline int ovl_remove_redirect(const char *pathname)
>>> +{
>>> +       return remove_xattr(pathname, OVL_REDIRECT_XATTR);
>>> +}
>>> +
>>> +static inline int ovl_create_whiteout(const char *pathname)
>>> +{
>>> +       int ret;
>>> +
>>> +       ret = mknod(pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0));
>>> +       if (ret)
>>> +               print_err(_("Cannot mknod %s:%s\n"),
>>> +                           pathname, strerror(errno));
>>> +       return ret;
>>> +}
>>> +
>>> +/*
>>> + * Scan each lower dir lower than 'start' and check type matching,
>>> + * we stop scan if we found something.
>>> + *
>>> + * skip: skip whiteout.
>>> + *
>>> + */
>>> +static int ovl_check_lower(const char *path, unsigned int start,
>>> +                          struct ovl_lower_check *chk, bool skip)
>>> +{
>>> +       char lower_path[PATH_MAX];
>>> +       struct stat st;
>>> +       unsigned int i;
>>> +
>>> +       for (i = start; i < lower_num; i++) {
>>> +               snprintf(lower_path, sizeof(lower_path), "%s%s", lowerdir[i], path);
>>> +
>>> +               if (lstat(lower_path, &st) != 0) {
>>
>> IMO it would be better to keep open fd for lower layers root and use fstatat()
>> with layer root fd.
>>
>>> +                       if (errno != ENOENT && errno != ENOTDIR) {
>>> +                               print_err(_("Cannot stat %s: %s\n"),
>>> +                                           lower_path, strerror(errno));
>>> +                               return -1;
>>> +                       }
>>> +                       continue;
>>> +               }
>>> +
>>> +               if (skip && is_whiteout(&st))
>>> +                       continue;
>>> +
>>> +               chk->exist = true;
>>> +               chk->st = st;
>>> +               strncpy(chk->path, lower_path, sizeof(chk->path));
>>> +               break;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +/*
>>> + * Scan each underlying dirs under specified dir if a whiteout is
>>> + * found, check it's orphan or not. In auto-mode, orphan whiteouts
>>> + * will be removed directly.
>>> + */
>>> +static int ovl_check_whiteout(struct scan_ctx *sctx)
>>> +{
>>> +       const char *pathname = sctx->pathname;
>>> +       const struct stat *st = sctx->st;
>>> +       struct ovl_lower_check chk = {0};
>>> +       unsigned int start;
>>> +       int ret = 0;
>>> +
>>> +       /* Is a whiteout ? */
>>> +       if (!is_whiteout(st))
>>> +               return 0;
>>> +
>>> +       /* Is Whiteout in the bottom lower dir ? */
>>> +       if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
>>> +               goto remove;
>>> +
>>> +       /*
>>> +        * Scan each corresponding lower directroy under this layer,
>>> +        * check is there a file or dir with the same name.
>>> +        */
>>> +       start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
>>> +       ret = ovl_check_lower(pathname + sctx->dirlen, start, &chk, true);
>>> +       if (ret)
>>> +               return ret;
>>> +       if (chk.exist && !is_whiteout(&chk.st))
>>> +               goto out;
>>> +
>>> +remove:
>>> +       /* Remove orphan whiteout directly or ask user */
>>> +       print_info(_("Orphan whiteout: %s "), pathname);
>>> +       if (!ask_question("Remove", 1))
>>> +               return 0;
>>> +
>>> +       ret = unlink(pathname);
>>> +       if (ret) {
>>> +               print_err(_("Cannot unlink %s: %s\n"), pathname,
>>> +                           strerror(errno));
>>> +               return ret;
>>> +       }
>>> +out:
>>> +       return ret;
>>> +}
>>> +
>>> +/*
>>> + * Scan each underlying under specified dir if an opaque dir is found,
>>> + * check the opaque xattr is invalid or not. In auto-mode, invalid
>>> + * opaque xattr will be removed directly.
>>> + * Do the follow checking:
>>> + * 1) Check lower matching name exist or not.
>>> + * 2) Check parent dir is merged or pure.
>>> + * If no lower matching and parent is not merged, remove opaque xattr.
>>> + */
>>> +static int ovl_check_opaque(struct scan_ctx *sctx)
>>> +{
>>> +       const char *pathname = sctx->pathname;
>>> +       char parent_path[PATH_MAX];
>>> +       struct ovl_lower_check chk = {0};
>>> +       unsigned int start;
>>> +       int ret = 0;
>>> +
>>> +       /* Is opaque ? */
>>> +       if (!ovl_is_opaque(pathname))
>>> +               goto out;
>>> +
>>> +       /* Opaque dir in last lower dir ? */
>>> +       if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
>>> +               goto remove;
>>> +
>>> +       /*
>>> +        * Scan each corresponding lower directroy under this layer,
>>> +        * check if there is a file or dir with the same name.
>>> +        */
>>> +       start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
>>> +       ret = ovl_check_lower(pathname + sctx->dirlen, start, &chk, true);
>>> +       if (ret)
>>> +               return ret;
>>> +       if (chk.exist && !is_whiteout(&chk.st))
>>> +               goto out;
>>> +
>>> +       /* Check parent directory merged or pure */
>>> +       memcpy(parent_path, pathname, sctx->pathlen-sctx->filelen);
>>> +       ret = ovl_check_lower(parent_path + sctx->dirlen, start, &chk, false);
>>> +       if (ret)
>>> +               return ret;
>>> +       if (chk.exist && is_dir(&chk.st))
>>> +               goto out;
>>> +
>>> +remove:
>>> +       /* Remove opaque xattr or ask user */
>>> +       print_info(_("Invalid opaque xattr: %s "), pathname);
>>> +       if (!ask_question("Remove", 1))
>>> +               return 0;
>>> +
>>> +       ret = ovl_remove_opaque(pathname);
>>> +out:
>>> +       return ret;
>>> +}
>>> +
>>> +static struct ovl_redirect_entry *redirect_list = NULL;
>>> +
>>> +static void ovl_redirect_entry_add(const char *path, int dirtype,
>>> +                                  int dirnum, const char *origin)
>>> +{
>>> +       struct ovl_redirect_entry *last, *new;
>>> +
>>> +       new = smalloc(sizeof(*new));
>>> +
>>> +       print_debug(_("Redirect entry add: [%s %s %s %d]\n"),
>>> +                     origin, path, (dirtype == OVL_UPPER) ? "UP" : "LOW",
>>> +                     (dirtype == OVL_UPPER) ? 0 : dirnum);
>>> +
>>> +       if (!redirect_list) {
>>> +               redirect_list = new;
>>> +       } else {
>>> +               for (last = redirect_list; last->next; last = last->next);
>>> +               last->next = new;
>>> +       }
>>> +       new->next = NULL;
>>> +       new->dirtype = dirtype;
>>> +       new->dirnum = dirnum;
>>> +       strncpy(new->origin, origin, sizeof(new->origin));
>>> +       strncpy(new->path, path, sizeof(new->path));
>>> +}
>>> +
>>> +static bool vol_redirect_entry_find(const char *origin, int dirtype,
>>> +                                   int dirnum, char **founded)
>>> +{
>>> +       struct ovl_redirect_entry *entry;
>>> +
>>> +       if (!redirect_list)
>>> +               return false;
>>> +
>>> +       for (entry = redirect_list; entry; entry = entry->next) {
>>> +               bool same_layer;
>>> +
>>> +               print_debug(_("Redirect entry found:[%s %s %s %d]\n"),
>>> +                             entry->origin, entry->path,
>>> +                             (entry->dirtype == OVL_UPPER) ? "UP" : "LOW",
>>> +                             (entry->dirtype == OVL_UPPER) ? 0 : entry->dirnum);
>>> +
>>> +               same_layer = ((entry->dirtype == dirtype) &&
>>> +                             (dirtype == OVL_LOWER ? (entry->dirnum == dirnum) : true));
>>> +
>>> +               if (same_layer && !strcmp(entry->origin, origin)) {
>>> +                       *founded = entry->path;
>>> +                       return true;
>>> +               }
>>> +       }
>>> +
>>> +       return false;
>>> +}
>>> +
>>> +static void vol_redirect_free(void)
>>> +{
>>> +       struct ovl_redirect_entry *entry;
>>> +
>>> +       while (redirect_list) {
>>> +               entry = redirect_list;
>>> +               redirect_list = redirect_list->next;
>>> +               free(entry);
>>> +       }
>>> +}
>>> +
>>> +/*
>>> + * Get redirect origin directory stored in the xattr, check it's invlaid
>>> + * or not, In auto-mode, invalid redirect xattr will be removed directly.
>>> + * Do the follow checking:
>>> + * 1) Check the origin directory exist or not. If not, remove xattr.
>>> + * 2) Count how many directories the origin directory was redirected by.
>>> + *    If more than one in the same layer, there must be some inconsistency
>>> + *    but not sure, just warn.
>>> + * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
>>> + */
>>> +static int ovl_check_redirect(struct scan_ctx *sctx)
>>> +{
>>> +       const char *pathname = sctx->pathname;
>>> +       struct ovl_lower_check chk = {0};
>>> +       char redirect_rpath[PATH_MAX];
>>> +       struct stat rst;
>>> +       char *redirect = NULL;
>>> +       unsigned int start;
>>> +       int ret = 0;
>>> +
>>> +       /* Get redirect */
>>> +       ret = ovl_get_redirect(pathname, sctx->dirlen,
>>> +                              sctx->filelen, &redirect);
>>> +       if (ret || !redirect)
>>> +               return ret;
>>> +
>>> +       print_debug(_("Dir %s has redirect %s\n"), pathname, redirect);
>>> +
>>> +       /* Redirect dir in last lower dir ? */
>>> +       if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
>>> +               goto remove;
>>> +
>>> +       /* Scan lower directories to check redirect dir exist or not */
>>> +       start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
>>> +       ret = ovl_check_lower(redirect, start, &chk, false);
>>> +       if (ret)
>>> +               goto out;
>>> +       if (chk.exist && is_dir(&chk.st)) {
>>> +               char *tmp;
>>> +
>>> +               /* Check duplicate in same layer */
>>> +               if (vol_redirect_entry_find(chk.path, sctx->dirtype,
>>> +                                           sctx->num, &tmp)) {
>>> +                       print_info("Duplicate redirect directories found:\n");
>>> +                       print_info("origin:%s current:%s latest:%s\n",
>>> +                                  chk.path, pathname, tmp);
>>> +
>>> +                       set_st_inconsistency(&status);
>>> +               }
>>> +
>>> +               ovl_redirect_entry_add(pathname, sctx->dirtype,
>>> +                                      sctx->num, chk.path);
>>> +
>>> +               /* Check and fix whiteout or opaque dir */
>>> +               snprintf(redirect_rpath, sizeof(redirect_rpath), "%s%s",
>>> +                        sctx->dirname, redirect);
>>> +               if (lstat(redirect_rpath, &rst) != 0) {
>>> +                       if (errno != ENOENT && errno != ENOTDIR) {
>>> +                               print_err(_("Cannot stat %s: %s\n"),
>>> +                                           redirect_rpath, strerror(errno));
>>> +                               goto out;
>>> +                       }
>>> +
>>> +                       /* Found nothing, create a whiteout */
>>> +                       ret = ovl_create_whiteout(redirect_rpath);
>>> +
>>> +               } else if (is_dir(&rst) && !ovl_is_opaque(redirect_rpath)) {
>>> +                       /* Found a directory but not opaqued, fix opaque xattr */
>>> +                       ret = ovl_set_opaque(redirect_rpath);
>>> +               }
>>> +
>>> +               goto out;
>>> +       }
>>> +
>>> +remove:
>>> +       /* Remove redirect xattr or ask user */
>>> +       print_info(_("Invalid redirect xattr: %s "), pathname);
>>> +       if (!ask_question("Remove", 1))
>>> +               goto out;
>>> +
>>> +       ret = ovl_remove_redirect(pathname);
>>> +out:
>>> +       free(redirect);
>>> +       return ret;
>>> +}
>>> +
>>> +static struct scan_operations ovl_scan_ops = {
>>> +       .whiteout = ovl_check_whiteout,
>>> +       .opaque = ovl_check_opaque,
>>> +       .redirect = ovl_check_redirect,
>>> +};
>>> +
>>> +static void ovl_scan_clean(void)
>>> +{
>>> +       /* Clean redirect entry record */
>>> +       vol_redirect_free();
>>> +}
>>> +
>>> +/* Scan upperdir and each lowerdirs, check and fix inconsistency */
>>> +int ovl_scan_fix(void)
>>> +{
>>> +       struct scan_ctx sctx;
>>> +       unsigned int i;
>>> +       int ret = 0;
>>> +
>>> +       if (flags | FL_VERBOSE)
>>> +               print_info(_("Scan and fix: [whiteouts|opaque|redirectdir]\n"));
>>> +
>>> +       /* Scan upper directory */
>>> +       if (flags | FL_VERBOSE)
>>> +               print_info(_("Scan upper directory: %s\n"), upperdir);
>>> +
>>> +       sctx.dirname = upperdir;
>>> +       sctx.dirlen = strlen(upperdir);
>>> +       sctx.dirtype = OVL_UPPER;
>>> +
>>> +       ret = scan_dir(&sctx, &ovl_scan_ops);
>>> +       if (ret)
>>> +               goto out;
>>> +
>>> +       /* Scan every lower directories */
>>> +       for (i = 0; i < lower_num; i++) {
>>> +               if (flags | FL_VERBOSE)
>>> +                       print_info(_("Scan upper directory: %s\n"), lowerdir[i]);
>>> +
>>> +               sctx.dirname = lowerdir[i];
>>> +               sctx.dirlen = strlen(lowerdir[i]);
>>> +               sctx.dirtype = OVL_LOWER;
>>> +               sctx.num = i;
>>> +
>>> +               ret = scan_dir(&sctx, &ovl_scan_ops);
>>> +               if (ret)
>>> +                       goto out;
>>> +       }
>>> +out:
>>> +       ovl_scan_clean();
>>> +       return ret;
>>> +}
>>> diff --git a/check.h b/check.h
>>> new file mode 100644
>>> index 0000000..373ff3a
>>> --- /dev/null
>>> +++ b/check.h
>>> @@ -0,0 +1,7 @@
>>> +#ifndef OVL_WHITECHECK_H
>>> +#define OVL_WHITECHECK_H
>>> +
>>> +/* Scan upperdir and each lowerdirs, check and fix inconsistency */
>>> +int ovl_scan_fix(void);
>>> +
>>> +#endif /* OVL_WHITECHECK_H */
>>> diff --git a/common.c b/common.c
>>> new file mode 100644
>>> index 0000000..4e77045
>>> --- /dev/null
>>> +++ b/common.c
>>> @@ -0,0 +1,95 @@
>>> +/*
>>> + *
>>> + *     Common things for all utilities
>>> + *
>>> + *     zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
>>> + *
>>> + */
>>> +
>>> +#include <stdio.h>
>>> +#include <string.h>
>>> +#include <stdlib.h>
>>> +#include <unistd.h>
>>> +#include <stdarg.h>
>>> +#include <errno.h>
>>> +#include <sys/types.h>
>>> +#include <sys/stat.h>
>>> +#include "common.h"
>>> +#include "config.h"
>>> +
>>> +extern char *program_name;
>>> +
>>> +/* #define DEBUG 1 */
>>> +#ifdef DEBUG
>>> +void print_debug(char *fmtstr, ...)
>>> +{
>>> +       va_list args;
>>> +
>>> +       va_start(args, fmtstr);
>>> +       fprintf(stdout, "%s:[Debug]: ", program_name);
>>> +       vfprintf(stdout, fmtstr, args);
>>> +       va_end(args);
>>> +}
>>> +#else
>>> +void print_debug (char *fmtstr, ...) {}
>>> +#endif
>>> +
>>> +void print_info(char *fmtstr, ...)
>>> +{
>>> +       va_list args;
>>> +
>>> +       va_start(args, fmtstr);
>>> +       vfprintf(stdout, fmtstr, args);
>>> +       va_end(args);
>>> +}
>>> +
>>> +void print_err(char *fmtstr, ...)
>>> +{
>>> +       va_list args;
>>> +
>>> +       va_start(args, fmtstr);
>>> +       fprintf(stderr, "%s:[Error]: ", program_name);
>>> +       vfprintf(stderr, fmtstr, args);
>>> +       va_end(args);
>>> +}
>>> +
>>> +void *smalloc(size_t size)
>>> +{
>>> +       void *new = malloc(size);
>>> +
>>> +       if (!new) {
>>> +               print_err(_("malloc error:%s\n"), strerror(errno));
>>> +               exit(1);
>>> +       }
>>> +
>>> +       memset(new, 0, size);
>>> +       return new;
>>> +}
>>> +
>>> +void *srealloc(void *addr, size_t size)
>>> +{
>>> +       void *re = realloc(addr, size);
>>> +
>>> +       if (!re) {
>>> +               print_err(_("malloc error:%s\n"), strerror(errno));
>>> +               exit(1);
>>> +       }
>>> +       return re;
>>> +}
>>> +
>>> +char *sstrdup(const char *src)
>>> +{
>>> +       char *dst = strdup(src);
>>> +
>>> +       if (!dst) {
>>> +               print_err(_("strdup error:%s\n"), strerror(errno));
>>> +               exit(1);
>>> +       }
>>> +
>>> +       return dst;
>>> +}
>>> +
>>> +void version(void)
>>> +{
>>> +       printf(_("Overlay utilities version %s\n"), PACKAGE_VERSION);
>>> +}
>>> diff --git a/common.h b/common.h
>>> new file mode 100644
>>> index 0000000..c4707e7
>>> --- /dev/null
>>> +++ b/common.h
>>> @@ -0,0 +1,34 @@
>>> +#ifndef OVL_COMMON_H
>>> +#define OVL_COMMON_H
>>> +
>>> +#ifndef __attribute__
>>> +# if !defined __GNUC__ || __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 8) || __STRICT_ANSI__
>>> +#  define __attribute__(x)
>>> +# endif
>>> +#endif
>>> +
>>> +#ifdef USE_GETTEXT
>>> +#include <libintl.h>
>>> +#define _(x)   gettext((x))
>>> +#else
>>> +#define _(x)   (x)
>>> +#endif
>>> +
>>> +/* Print an error message */
>>> +void print_err(char *, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
>>> +
>>> +/* Print an info message */
>>> +void print_info(char *, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
>>> +
>>> +/* Print an debug message */
>>> +void print_debug(char *, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
>>> +
>>> +/* Safety wrapper */
>>> +void *smalloc(size_t size);
>>> +void *srealloc(void *addr, size_t size);
>>> +char *sstrdup(const char *src);
>>> +
>>> +/* Print program version */
>>> +void version(void);
>>> +
>>> +#endif /* OVL_COMMON_H */
>>> diff --git a/config.h b/config.h
>>> new file mode 100644
>>> index 0000000..deac089
>>> --- /dev/null
>>> +++ b/config.h
>>> @@ -0,0 +1,22 @@
>>> +#ifndef OVL_CONFIG_H
>>> +#define OVL_CONFIG_H
>>> +
>>> +/* program version */
>>> +#define PACKAGE_VERSION        "v1.0.0"
>>> +
>>> +/* overlay max lower stacks (the same to kernel overlayfs driver) */
>>> +#define OVL_MAX_STACK 500
>>> +
>>> +/* File with mounted filesystems */
>>> +#define MOUNT_TAB "/proc/mounts"
>>> +
>>> +/* Name of overlay filesystem type */
>>> +#define OVERLAY_NAME "overlay"
>>> +#define OVERLAY_NAME_OLD "overlayfs"
>>> +
>>> +/* Mount options */
>>> +#define OPT_LOWERDIR "lowerdir="
>>> +#define OPT_UPPERDIR "upperdir="
>>> +#define OPT_WORKDIR "workdir="
>>> +
>>> +#endif
>>> diff --git a/fsck.c b/fsck.c
>>> new file mode 100644
>>> index 0000000..cbcb8e9
>>> --- /dev/null
>>> +++ b/fsck.c
>>> @@ -0,0 +1,179 @@
>>> +/*
>>> + *
>>> + *     Utility to fsck overlay
>>> + *
>>> + *     zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
>>> + *
>>> + */
>>> +
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <errno.h>
>>> +#include <getopt.h>
>>> +#include <libgen.h>
>>> +#include <stdbool.h>
>>> +#include <sys/types.h>
>>> +#include <sys/stat.h>
>>> +#include <linux/limits.h>
>>> +
>>> +#include "common.h"
>>> +#include "config.h"
>>> +#include "lib.h"
>>> +#include "check.h"
>>> +#include "mount.h"
>>> +
>>> +char *program_name;
>>> +
>>> +char **lowerdir;
>>> +char upperdir[PATH_MAX] = {0};
>>> +char workdir[PATH_MAX] = {0};
>>> +unsigned int lower_num;
>>> +int flags;             /* user input option flags */
>>> +int status;            /* fsck scan status */
>>> +
>>> +/* Cleanup lower directories buf */
>>> +static void ovl_clean_lowerdirs(void)
>>> +{
>>> +       unsigned int i;
>>> +
>>> +       for (i = 0; i < lower_num; i++) {
>>> +               free(lowerdir[i]);
>>> +               lowerdir[i] = NULL;
>>> +               lower_num = 0;
>>> +       }
>>> +       free(lowerdir);
>>> +       lowerdir = NULL;
>>> +}
>>> +
>>> +static void usage(void)
>>> +{
>>> +       print_info(_("Usage:\n\t%s [-l lowerdir] [-u upperdir] [-w workdir] "
>>> +                   "[-avhV]\n\n"), program_name);
>>> +       print_info(_("Options:\n"
>>> +                   "-l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,\n"
>>> +                   "                          multiple lower use ':' as separator\n"
>>> +                   "-u, --upperdir=UPPERDIR   specify upper directory of overlayfs\n"
>>> +                   "-w, --workdir=WORKDIR     specify work directory of overlayfs\n"
>>> +                   "-a, --auto                repair automatically (no questions)\n"
>>> +                   "-v, --verbose             print more messages of overlayfs\n"
>>> +                   "-h, --help                display this usage of overlayfs\n"
>>> +                   "-V, --version             display version information\n"));
>>> +       exit(1);
>>> +}
>>> +
>>> +static void parse_options(int argc, char *argv[])
>>> +{
>>> +       char *lowertemp;
>>> +       int c;
>>> +       int ret = 0;
>>> +
>>> +       struct option long_options[] = {
>>> +               {"lowerdir", required_argument, NULL, 'l'},
>>> +               {"upperdir", required_argument, NULL, 'u'},
>>> +               {"workdir", required_argument, NULL, 'w'},
>>> +               {"auto", no_argument, NULL, 'a'},
>>> +               {"verbose", no_argument, NULL, 'v'},
>>> +               {"version", no_argument, NULL, 'V'},
>>> +               {"help", no_argument, NULL, 'h'},
>>> +               {NULL, 0, NULL, 0}
>>> +       };
>>> +
>>> +       while ((c = getopt_long(argc, argv, "l:u:w:avVh", long_options, NULL)) != -1) {
>>> +               switch (c) {
>>> +               case 'l':
>>> +                       lowertemp = strdup(optarg);
>>> +                       ret = ovl_resolve_lowerdirs(lowertemp, &lowerdir, &lower_num);
>>> +                       free(lowertemp);
>>> +                       break;
>>> +               case 'u':
>>> +                       if (realpath(optarg, upperdir)) {
>>> +                               print_debug(_("Upperdir:%s\n"), upperdir);
>>> +                               flags |= FL_UPPER;
>>> +                       } else {
>>> +                               print_err(_("Failed to resolve upperdir:%s\n"), optarg);
>>> +                               ret = -1;
>>> +                       }
>>> +                       break;
>>> +               case 'w':
>>> +                       if (realpath(optarg, workdir)) {
>>> +                               print_debug(_("Workdir:%s\n"), workdir);
>>> +                               flags |= FL_WORK;
>>> +                       } else {
>>> +                               print_err(_("Failed to resolve workdir:%s\n"), optarg);
>>> +                               ret = -1;
>>> +                       }
>>> +                       break;
>>> +               case 'a':
>>> +                       flags |= FL_AUTO;
>>> +                       break;
>>> +               case 'v':
>>> +                       flags |= FL_VERBOSE;
>>> +                       break;
>>> +               case 'V':
>>> +                       version();
>>> +                       return;
>>> +               case 'h':
>>> +               default:
>>> +                       usage();
>>> +                       return;
>>> +               }
>>> +
>>> +               if (ret)
>>> +                       exit(1);
>>> +       }
>>> +
>>> +       if (!lower_num || (!(flags & FL_UPPER) && lower_num == 1)) {
>>> +               print_info(_("Please specify correct lowerdirs and upperdir\n"));
>>> +               usage();
>>> +       }
>>> +}
>>> +
>>> +void fsck_status_check(int *val)
>>> +{
>>> +       if (status & OVL_ST_INCONSISTNECY) {
>>> +               *val |= FSCK_UNCORRECTED;
>>> +               print_info(_("Still have unexpected inconsistency!\n"));
>>> +       }
>>> +
>>> +       if (status & OVL_ST_ABORT) {
>>> +               *val |= FSCK_ERROR;
>>> +               print_info(_("Cannot continue, aborting\n"));
>>> +       }
>>> +}
>>> +
>>> +int main(int argc, char *argv[])
>>> +{
>>> +       bool mounted;
>>> +       int err = 0;
>>> +       int exit_value = 0;
>>> +
>>> +       program_name = basename(argv[0]);
>>> +
>>> +       parse_options(argc, argv);
>>> +
>>> +       /* Ensure overlay filesystem not mounted */
>>> +       if ((err = ovl_check_mount(&mounted)))
>>> +               goto out;
>>> +       if (!mounted) {
>>> +               set_st_abort(&status);
>>> +               goto out;
>>> +       }
>>> +
>>> +       /* Scan and fix */
>>> +       if ((err = ovl_scan_fix()))
>>> +               goto out;
>>> +
>>> +out:
>>> +       fsck_status_check(&exit_value);
>>> +       ovl_clean_lowerdirs();
>>> +
>>> +       if (err)
>>> +               exit_value |= FSCK_ERROR;
>>> +       if (exit_value)
>>> +               print_info("WARNING: Filesystem check failed, may not clean\n");
>>> +       else
>>> +               print_info("Filesystem clean\n");
>>> +
>>> +       return exit_value;
>>> +}
>>> diff --git a/lib.c b/lib.c
>>> new file mode 100644
>>> index 0000000..a6832fe
>>> --- /dev/null
>>> +++ b/lib.c
>>> @@ -0,0 +1,197 @@
>>> +/*
>>> + *
>>> + *     Common things for all utilities
>>> + *
>>> + *     zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
>>> + *
>>> + */
>>> +
>>> +#include <stdlib.h>
>>> +#include <stdio.h>
>>> +#include <unistd.h>
>>> +#include <errno.h>
>>> +#include <string.h>
>>> +#include <stdbool.h>
>>> +#include <sys/types.h>
>>> +#include <sys/stat.h>
>>> +#include <sys/xattr.h>
>>> +#include <fts.h>
>>> +
>>> +#include "common.h"
>>> +#include "lib.h"
>>> +
>>> +extern int flags;
>>> +extern int status;
>>> +
>>> +static int ask_yn(const char *question, int def)
>>> +{
>>> +       char ans[16];
>>> +
>>> +       print_info(_("%s ? [%s]: \n"), question, def ? _("y") : _("n"));
>>> +       fflush(stdout);
>>> +       while (fgets(ans, sizeof(ans)-1, stdin)) {
>>> +               if (ans[0] == '\n')
>>> +                       return def;
>>> +               else if (!strcasecmp(ans, "y\n") || !strcasecmp(ans, "yes\n"))
>>> +                       return 1;
>>> +               else if (!strcasecmp(ans, "n\n") || !strcasecmp(ans, "no\n"))
>>> +                       return 0;
>>> +               else
>>> +                       print_info(_("Illegal answer. Please input y/n or yes/no:"));
>>> +               fflush(stdout);
>>> +       }
>>> +       return def;
>>> +}
>>> +
>>> +/* Ask user */
>>> +int ask_question(const char *question, int def)
>>> +{
>>> +       if (flags & FL_AUTO) {
>>> +               print_info(_("%s? %s\n"), question, def ? _("y") : _("n"));
>>> +               return def;
>>> +       }
>>> +
>>> +       return ask_yn(question, def);
>>> +}
>>> +
>>> +ssize_t get_xattr(const char *pathname, const char *xattrname,
>>> +                 char **value, bool *exist)
>>> +{
>>> +       char *buf = NULL;
>>> +       ssize_t ret;
>>> +
>>> +       ret = getxattr(pathname, xattrname, NULL, 0);
>>> +       if (ret < 0) {
>>> +               if (errno == ENODATA || errno == ENOTSUP) {
>>> +                       if (exist)
>>> +                               *exist = false;
>>> +                       return 0;
>>> +               } else {
>>> +                       goto fail;
>>> +               }
>>> +       }
>>> +
>>> +       /* Zero size value means xattr exist but value unknown */
>>> +       if (exist)
>>> +               *exist = true;
>>> +       if (ret == 0 || !value)
>>> +               return 0;
>>> +
>>> +       buf = smalloc(ret+1);
>>> +       ret = getxattr(pathname, xattrname, buf, ret);
>>> +       if (ret <= 0)
>>> +               goto fail2;
>>> +
>>> +       buf[ret] = '\0';
>>> +       *value = buf;
>>> +       return ret;
>>> +
>>> +fail2:
>>> +       free(buf);
>>> +fail:
>>> +       print_err(_("Cannot getxattr %s %s: %s\n"), pathname,
>>> +                   xattrname, strerror(errno));
>>> +       return -1;
>>> +}
>>> +
>>> +int set_xattr(const char *pathname, const char *xattrname,
>>> +               void *value, size_t size)
>>> +{
>>> +       int ret;
>>> +
>>> +       ret = setxattr(pathname, xattrname, value, size, XATTR_CREATE);
>>> +       if (ret && ret != EEXIST)
>>> +               goto fail;
>>> +
>>> +       if (ret == EEXIST) {
>>> +               ret = setxattr(pathname, xattrname, value, size, XATTR_REPLACE);
>>> +               if (ret)
>>> +                       goto fail;
>>> +       }
>>> +
>>> +       return 0;
>>> +fail:
>>> +       print_err(_("Cannot setxattr %s %s: %s\n"), pathname,
>>> +                   xattrname, strerror(errno));
>>> +       return ret;
>>> +}
>>> +
>>> +int remove_xattr(const char *pathname, const char *xattrname)
>>> +{
>>> +       int ret;
>>> +       if ((ret = removexattr(pathname, xattrname)))
>>> +               print_err(_("Cannot removexattr %s %s: %s\n"), pathname,
>>> +                           xattrname, strerror(errno));
>>> +       return ret;
>>> +}
>>> +
>>> +static inline int __check_entry(struct scan_ctx *sctx,
>>> +                                 int (*do_check)(struct scan_ctx *))
>>> +{
>>> +       return do_check ? do_check(sctx) : 0;
>>> +}
>>> +
>>> +/* Scan specified directories and invoke callback */
>>> +int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
>>> +{
>>> +       char *paths[2] = {(char *)sctx->dirname, NULL};
>>> +       FTS *ftsp;
>>> +       FTSENT *ftsent;
>>> +       int ret = 0;
>>> +
>>> +       ftsp = fts_open(paths, FTS_NOCHDIR | FTS_PHYSICAL, NULL);
>>> +       if (ftsp == NULL) {
>>> +               print_err(_("Failed to fts open %s:%s\n"),
>>> +                           sctx->dirname, strerror(errno));
>>> +               return -1;
>>> +       }
>>> +
>>> +       while ((ftsent = fts_read(ftsp)) != NULL) {
>>> +               int err;
>>> +
>>> +               print_debug(_("Scan:%-3s %2d %7jd   %-40s %s\n"),
>>> +                       (ftsent->fts_info == FTS_D) ? "d" :
>>> +                       (ftsent->fts_info == FTS_DNR) ? "dnr" :
>>> +                       (ftsent->fts_info == FTS_DP) ? "dp" :
>>> +                       (ftsent->fts_info == FTS_F) ? "f" :
>>> +                       (ftsent->fts_info == FTS_NS) ? "ns" :
>>> +                       (ftsent->fts_info == FTS_SL) ? "sl" :
>>> +                       (ftsent->fts_info == FTS_SLNONE) ? "sln" :
>>> +                       (ftsent->fts_info == FTS_DEFAULT) ? "df" : "???",
>>> +                       ftsent->fts_level, ftsent->fts_statp->st_size,
>>> +                       ftsent->fts_path, ftsent->fts_name);
>>> +
>>> +
>>> +               /* Fillup base context */
>>> +               sctx->pathname = ftsent->fts_path;
>>> +               sctx->pathlen = ftsent->fts_pathlen;
>>> +               sctx->filename = ftsent->fts_name;
>>> +               sctx->filelen = ftsent->fts_namelen;
>>> +               sctx->st = ftsent->fts_statp;
>>> +
>>> +               switch (ftsent->fts_info) {
>>> +               case FTS_DEFAULT:
>>> +                       /* Check whiteouts */
>>> +                       err = __check_entry(sctx, sop->whiteout);
>>> +                       ret = (ret || !err) ? ret : err;
>>> +                       break;
>>> +               case FTS_D:
>>> +                       /* Check opaque and redirect */
>>> +                       err = __check_entry(sctx, sop->opaque);
>>> +                       ret = (ret || !err) ? ret : err;
>>> +
>>> +                       err = __check_entry(sctx, sop->redirect);
>>> +                       ret = (ret || !err) ? ret : err;
>>> +                       break;
>>> +               case FTS_NS:
>>> +               case FTS_DNR:
>>> +               case FTS_ERR:
>>> +                       print_err(_("Failed to fts read %s:%s\n"),
>>> +                                   ftsent->fts_path, strerror(ftsent->fts_errno));
>>> +                       goto out;
>>> +               }
>>> +       }
>>> +out:
>>> +       fts_close(ftsp);
>>> +       return ret;
>>> +}
>>> diff --git a/lib.h b/lib.h
>>> new file mode 100644
>>> index 0000000..463b263
>>> --- /dev/null
>>> +++ b/lib.h
>>> @@ -0,0 +1,73 @@
>>> +#ifndef OVL_LIB_H
>>> +#define OVL_LIB_H
>>> +
>>> +/* Common return value */
>>> +#define FSCK_OK          0     /* No errors */
>>> +#define FSCK_NONDESTRUCT 1     /* File system errors corrected */
>>> +#define FSCK_REBOOT      2     /* System should be rebooted */
>>> +#define FSCK_UNCORRECTED 4     /* File system errors left uncorrected */
>>> +#define FSCK_ERROR       8     /* Operational error */
>>> +#define FSCK_USAGE       16    /* Usage or syntax error */
>>> +#define FSCK_CANCELED   32     /* Aborted with a signal or ^C */
>>> +#define FSCK_LIBRARY     128   /* Shared library error */
>>> +
>>> +/* Fsck status */
>>> +#define OVL_ST_INCONSISTNECY   (1 << 0)
>>> +#define OVL_ST_ABORT           (1 << 1)
>>> +
>>> +/* Option flags */
>>> +#define FL_VERBOSE     (1 << 0)        /* verbose */
>>> +#define FL_UPPER       (1 << 1)        /* specify upper directory */
>>> +#define FL_WORK                (1 << 2)        /* specify work directory */
>>> +#define FL_AUTO                (1 << 3)        /* automactically scan dirs and repair */
>>> +
>>> +/* Scan path type */
>>> +#define OVL_UPPER      0
>>> +#define OVL_LOWER      1
>>> +#define OVL_WORKER     2
>>> +#define OVL_PTYPE_MAX  3
>>> +
>>> +/* Xattr */
>>> +#define OVL_OPAQUE_XATTR       "trusted.overlay.opaque"
>>> +#define OVL_REDIRECT_XATTR     "trusted.overlay.redirect"
>>> +
>>> +/* Directories scan data struct */
>>> +struct scan_ctx {
>>> +       const char *dirname;    /* upper/lower root dir */
>>> +       size_t dirlen;          /* strlen(dirlen) */
>>> +       int dirtype;            /* OVL_UPPER or OVL_LOWER */
>>> +       int num;                /* lower dir depth, lower type use only */
>>> +
>>> +       const char *pathname;   /* file path from the root */
>>> +       size_t pathlen;         /* strlen(pathname) */
>>> +       const char *filename;   /* filename */
>>> +       size_t filelen;         /* strlen(filename) */
>>> +       struct stat *st;        /* file stat */
>>> +};
>>> +
>>> +/* Directories scan callback operations struct */
>>> +struct scan_operations {
>>> +       int (*whiteout)(struct scan_ctx *);
>>> +       int (*opaque)(struct scan_ctx *);
>>> +       int (*redirect)(struct scan_ctx *);
>>> +};
>>> +
>>> +static inline void set_st_inconsistency(int *st)
>>> +{
>>> +       *st |= OVL_ST_INCONSISTNECY;
>>> +}
>>> +
>>> +static inline void set_st_abort(int *st)
>>> +{
>>> +       *st |= OVL_ST_ABORT;
>>> +}
>>> +
>>> +int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop);
>>> +int ask_question(const char *question, int def);
>>> +ssize_t get_xattr(const char *pathname, const char *xattrname,
>>> +                 char **value, bool *exist);
>>> +int set_xattr(const char *pathname, const char *xattrname,
>>> +             void *value, size_t size);
>>> +int remove_xattr(const char *pathname, const char *xattrname);
>>> +
>>> +#endif /* OVL_LIB_H */
>>> diff --git a/mount.c b/mount.c
>>> new file mode 100644
>>> index 0000000..28ce8e5
>>> --- /dev/null
>>> +++ b/mount.c
>>> @@ -0,0 +1,319 @@
>>> +/*
>>> + *
>>> + *     Check mounted overlay
>>> + *
>>> + *     zhangyi (F) <yi.zhang@huawei.com> - Sponsored by Huawei CR
>>> + *
>>> + */
>>> +
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <errno.h>
>>> +#include <getopt.h>
>>> +#include <libgen.h>
>>> +#include <stdbool.h>
>>> +#include <mntent.h>
>>> +#include <sys/types.h>
>>> +#include <sys/stat.h>
>>> +#include <linux/limits.h>
>>> +
>>> +#include "common.h"
>>> +#include "config.h"
>>> +#include "lib.h"
>>> +#include "check.h"
>>> +#include "mount.h"
>>> +
>>> +struct ovl_mnt_entry {
>>> +       char *lowers;
>>> +       char **lowerdir;
>>> +       unsigned int lowernum;
>>> +       char upperdir[PATH_MAX];
>>> +       char workdir[PATH_MAX];
>>> +};
>>> +
>>> +/* Mount buf allocate a time */
>>> +#define ALLOC_NUM      16
>>> +
>>> +extern char **lowerdir;
>>> +extern char upperdir[];
>>> +extern char workdir[];
>>> +extern unsigned int lower_num;
>>> +
>>> +/*
>>> + * Split directories to individual one.
>>> + * (copied from linux kernel, see fs/overlayfs/super.c)
>>> + */
>>
>> It would be nice if such functions could be maintained in a file/dir
>> that is synced with the kernel, like the xfs/lib files.
>> For the first release we don't really have to sync this file with the
>> kernel, but at least keep them at a specific file/dir and maybe the
>> kernel driver will follow up later.
>>
>>> +static unsigned int ovl_split_lowerdirs(char *lower)
>>> +{
>>> +       unsigned int ctr = 1;
>>> +       char *s, *d;
>>> +
>>> +       for (s = d = lower;; s++, d++) {
>>> +               if (*s == '\\') {
>>> +                       s++;
>>> +               } else if (*s == ':') {
>>> +                       *d = '\0';
>>> +                       ctr++;
>>> +                       continue;
>>> +               }
>>> +               *d = *s;
>>> +               if (!*s)
>>> +                       break;
>>> +       }
>>> +       return ctr;
>>> +}
>>> +
>>> +/* Resolve each lower directories and check the validity */
>>> +int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
>>> +                         unsigned int *lowernum)
>>> +{
>>> +       unsigned int num;
>>> +       char **dirs;
>>> +       char *p;
>>> +       int i;
>>> +
>>> +       num = ovl_split_lowerdirs(loweropt);
>>> +       if (num > OVL_MAX_STACK) {
>>> +               print_err(_("Too many lower directories:%u, max:%u\n"),
>>> +                           num, OVL_MAX_STACK);
>>> +               return -1;
>>> +       }
>>> +
>>> +       dirs = smalloc(sizeof(char *) * num);
>>> +
>>> +       p = loweropt;
>>> +       for (i = 0; i < num; i++) {
>>> +               dirs[i] = smalloc(PATH_MAX);
>>> +               if (!realpath(p, dirs[i])) {
>>> +                       print_err(_("Failed to resolve lowerdir:%s:%s\n"),
>>> +                                   p, strerror(errno));
>>> +                       goto err;
>>> +               }
>>> +               print_debug(_("Lowerdir %u:%s\n"), i, dirs[i]);
>>> +               p = strchr(p, '\0') + 1;
>>> +       }
>>> +
>>> +       *lowerdir = dirs;
>>> +       *lowernum = num;
>>> +
>>> +       return 0;
>>> +err:
>>> +       for (i--; i >= 0; i--)
>>> +               free(dirs[i]);
>>> +       free(dirs);
>>> +       *lowernum = 0;
>>> +       return -1;
>>> +}
>>> +
>>> +/*
>>> + * Split and return next opt.
>>> + * (copied from linux kernel, see fs/overlayfs/super.c)
>>> + */
>>> +static char *ovl_next_opt(char **s)
>>> +{
>>> +       char *sbegin = *s;
>>> +       char *p;
>>> +
>>> +       if (sbegin == NULL)
>>> +               return NULL;
>>> +
>>> +       for (p = sbegin; *p; p++) {
>>> +               if (*p == '\\') {
>>> +                       p++;
>>> +                       if (!*p)
>>> +                               break;
>>> +               } else if (*p == ',') {
>>> +                       *p = '\0';
>>> +                       *s = p + 1;
>>> +                       return sbegin;
>>> +               }
>>> +       }
>>> +       *s = NULL;
>>> +       return sbegin;
>>> +}
>>> +
>>> +/*
>>> + * Split and parse opt to each directories.
>>> + *
>>> + * Note: FIXME: We cannot distinguish mounted directories if overlayfs was
>>> + * mounted use relative path, so there may have misjudgment.
>>> + */
>>> +static int ovl_parse_opt(char *opt, struct ovl_mnt_entry *entry)
>>> +{
>>> +       char tmp[PATH_MAX] = {0};
>>> +       char *p;
>>> +       int len;
>>> +       int ret;
>>> +       int i;
>>> +
>>> +       while ((p = ovl_next_opt(&opt)) != NULL) {
>>> +               if (!*p)
>>> +                       continue;
>>> +
>>> +               if (!strncmp(p, OPT_UPPERDIR, strlen(OPT_UPPERDIR))) {
>>> +                       len = strlen(p) - strlen(OPT_UPPERDIR) + 1;
>>> +                       strncpy(tmp, p+strlen(OPT_UPPERDIR), len);
>>> +
>>> +                       if (!realpath(tmp, entry->upperdir)) {
>>> +                               print_err(_("Faile to resolve path:%s:%s\n"),
>>> +                                           tmp, strerror(errno));
>>> +                               ret = -1;
>>> +                               goto errout;
>>> +                       }
>>> +               } else if (!strncmp(p, OPT_LOWERDIR, strlen(OPT_LOWERDIR))) {
>>> +                       len = strlen(p) - strlen(OPT_LOWERDIR) + 1;
>>> +                       entry->lowers = smalloc(len);
>>> +                       strncpy(entry->lowers, p+strlen(OPT_LOWERDIR), len);
>>> +
>>> +                       if ((ret = ovl_resolve_lowerdirs(entry->lowers,
>>> +                                       &entry->lowerdir, &entry->lowernum)))
>>> +                               goto errout;
>>> +
>>> +               } else if (!strncmp(p, OPT_WORKDIR, strlen(OPT_WORKDIR))) {
>>> +                       len = strlen(p) - strlen(OPT_WORKDIR) + 1;
>>> +                       strncpy(tmp, p+strlen(OPT_WORKDIR), len);
>>> +
>>> +                       if (!realpath(tmp, entry->workdir)) {
>>> +                               print_err(_("Faile to resolve path:%s:%s\n"),
>>> +                                           tmp, strerror(errno));
>>> +                               ret = -1;
>>> +                               goto errout;
>>> +                       }
>>> +               }
>>> +       }
>>> +
>>> +errout:
>>> +       if (entry->lowernum) {
>>> +               for (i = 0; i < entry->lowernum; i++)
>>> +                       free(entry->lowerdir[i]);
>>> +               free(entry->lowerdir);
>>> +               entry->lowerdir = NULL;
>>> +               entry->lowernum = 0;
>>> +       }
>>> +       free(entry->lowers);
>>> +       entry->lowers = NULL;
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +/* Scan current mounted overlayfs and get used underlying directories */
>>> +static int ovl_scan_mount_init(struct ovl_mnt_entry **ovl_mnt_entries,
>>> +                              int *ovl_mnt_count)
>>> +{
>>> +       struct ovl_mnt_entry *mnt_entries;
>>> +       struct mntent *mnt;
>>> +       FILE *fp;
>>> +       char *opt;
>>> +       int allocated, num = 0;
>>> +
>>> +       fp = setmntent(MOUNT_TAB, "r");
>>> +       if (!fp) {
>>> +               print_err(_("Fail to setmntent %s:%s\n"),
>>> +                           MOUNT_TAB, strerror(errno));
>>> +               return -1;
>>> +       }
>>> +
>>> +       allocated = ALLOC_NUM;
>>> +       mnt_entries = smalloc(sizeof(struct ovl_mnt_entry) * allocated);
>>> +
>>> +       while ((mnt = getmntent(fp))) {
>>> +               if (!strcmp(mnt->mnt_type, OVERLAY_NAME) ||
>>> +                   !strcmp(mnt->mnt_type, OVERLAY_NAME_OLD)) {
>>> +
>>> +                       opt = sstrdup(mnt->mnt_opts);
>>> +                       if (ovl_parse_opt(opt, &mnt_entries[num])) {
>>> +                               free(opt);
>>> +                               continue;
>>> +                       }
>>> +
>>> +                       num++;
>>> +                       if (num % ALLOC_NUM == 0) {
>>> +                               allocated += ALLOC_NUM;
>>> +                               mnt_entries = srealloc(mnt_entries,
>>> +                                    sizeof(struct ovl_mnt_entry) * allocated);
>>> +                       }
>>> +
>>> +                       free(opt);
>>> +               }
>>> +       }
>>> +
>>> +       *ovl_mnt_entries = mnt_entries;
>>> +       *ovl_mnt_count = num;
>>> +
>>> +       endmntent(fp);
>>> +       return 0;
>>> +}
>>> +
>>> +static void ovl_scan_mount_exit(struct ovl_mnt_entry *ovl_mnt_entries,
>>> +                               int ovl_mnt_count)
>>> +{
>>> +       int i,j;
>>> +
>>> +       for (i = 0; i < ovl_mnt_count; i++) {
>>> +               for (j = 0; j < ovl_mnt_entries[i].lowernum; j++)
>>> +                       free(ovl_mnt_entries[i].lowerdir[j]);
>>> +               free(ovl_mnt_entries[i].lowerdir);
>>> +               free(ovl_mnt_entries[i].lowers);
>>> +       }
>>> +       free(ovl_mnt_entries);
>>> +}
>>> +
>>> +/*
>>> + * Scan every mounted filesystem, check the overlay directories want
>>> + * to check is already mounted. Check and fix an online overlay is not
>>> + * allowed.
>>> + *
>>> + * Note: fsck may modify lower layers, so even match only one directory
>>> + *       is triggered as mounted.
>>> + */
>>> +int ovl_check_mount(bool *pass)
>>> +{
>>> +       struct ovl_mnt_entry *ovl_mnt_entries;
>>> +       int ovl_mnt_entry_count;
>>> +       char *mounted_path;
>>> +       bool mounted;
>>> +       int i,j,k;
>>> +       int ret;
>>> +
>>> +       ret = ovl_scan_mount_init(&ovl_mnt_entries, &ovl_mnt_entry_count);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       /* Only check hard matching */
>>> +       for (i = 0; i < ovl_mnt_entry_count; i++) {
>>> +               /* Check lower */
>>> +               for (j = 0; j < ovl_mnt_entries[i].lowernum; j++) {
>>> +                       for (k = 0; k < lower_num; k++) {
>>> +                               if (!strcmp(lowerdir[k],
>>> +                                           ovl_mnt_entries[i].lowerdir[j])) {
>>> +                                       mounted_path = lowerdir[k];
>>> +                                       mounted = true;
>>> +                                       goto out;
>>> +                               }
>>> +                       }
>>> +               }
>>> +
>>> +               /* Check upper */
>>> +               if (!(strcmp(upperdir, ovl_mnt_entries[i].upperdir))) {
>>> +                       mounted_path = upperdir;
>>> +                       mounted = true;
>>> +                       goto out;
>>> +               }
>>> +
>>> +               /* Check worker */
>>> +               if (workdir[0] != '\0' && !(strcmp(workdir, ovl_mnt_entries[i].workdir))) {
>>> +                       mounted_path = workdir;
>>> +                       mounted = true;
>>> +                       goto out;
>>> +               }
>>> +       }
>>> +out:
>>> +       ovl_scan_mount_exit(ovl_mnt_entries, ovl_mnt_entry_count);
>>> +
>>> +       if (mounted)
>>> +               print_info(_("Dir %s is mounted\n"), mounted_path);
>>> +       *pass = !mounted;
>>> +
>>> +       return 0;
>>> +}
>>> diff --git a/mount.h b/mount.h
>>> new file mode 100644
>>> index 0000000..8a3762d
>>> --- /dev/null
>>> +++ b/mount.h
>>> @@ -0,0 +1,8 @@
>>> +#ifndef OVL_MOUNT_H
>>> +#define OVL_MOUNT_H
>>> +
>>> +int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
>>> +                          unsigned int *lowernum);
>>> +int ovl_check_mount(bool *mounted);
>>> +
>>> +#endif /* OVL_MOUNT_H */
>>> diff --git a/test/README.md b/test/README.md
>>> new file mode 100644
>>> index 0000000..71dbad8
>>> --- /dev/null
>>> +++ b/test/README.md
>>> @@ -0,0 +1,12 @@
>>> +fsck.overlay test
>>> +=================
>>> +
>>> +This test cases simulate different inconsistency of overlay filesystem
>>> +underlying directories, test fsck.overlay can repair them correctly or not.
>>> +
>>> +USAGE
>>> +=====
>>> +
>>> +1. Check "local.config", modify config value to appropriate one.
>>> +2. ./auto_test.sh
>>> +3. After testing, the result file and log file created in the result directory.
>>
>> This really sounds like a mini fork of xfstests.
>> I'd prefer if those tests went into xfstests and used fsck.overlay either as an
>> external program (like the rest of fsck.*) or as in-house test helper.
>>
>>> diff --git a/test/auto_test.sh b/test/auto_test.sh
>>> new file mode 100755
>>> index 0000000..8248e24
>>> --- /dev/null
>>> +++ b/test/auto_test.sh
>>> @@ -0,0 +1,46 @@
>>> +#!/bin/bash
>>> +
>>> +. ./src/prepare.sh
>>> +
>>> +echo "***************"
>>> +
>>> +# 1. Test whiteout
>>> +echo -e "1.Test Whiteout\n"
>>> +$SOURCE_DIR/whiteout_test.sh >> $LOG_FILE 2>&1
>>> +if [ $? -ne 0 ]; then
>>> +       echo -e "Result:\033[31m Fail\033[0m\n"
>>> +       RESULT="Fail"
>>> +else
>>> +       echo -e "Result:\033[32m Pass\033[0m\n"
>>> +       RESULT="Pass"
>>> +fi
>>> +
>>> +echo -e "Test whiteout: $RESULT" >> $RESOULT_FILE
>>> +
>>> +# 2. Test opaque dir
>>> +echo -e "2.Test opaque directory\n"
>>> +$SOURCE_DIR/opaque_test.sh >> $LOG_FILE 2>&1
>>> +if [ $? -ne 0 ]; then
>>> +       echo -e "Result:\033[31m Fail\033[0m\n"
>>> +       RESULT="Fail"
>>> +else
>>> +       echo -e "Result:\033[32m Pass\033[0m\n"
>>> +       RESULT="Pass"
>>> +fi
>>> +
>>> +echo -e "Test opaque directory: $RESULT" >> $RESOULT_FILE
>>> +
>>> +# 3. Test redirect dir
>>> +echo -e "3.Test redirect direcotry\n"
>>> +$SOURCE_DIR/redirect_test.sh >> $LOG_FILE 2>&1
>>> +if [ $? -ne 0 ]; then
>>> +       echo -e "Result:\033[31m Fail\033[0m\n"
>>> +       RESULT="Fail"
>>> +else
>>> +       echo -e "Result:\033[32m Pass\033[0m\n"
>>> +       RESULT="Pass"
>>> +fi
>>> +
>>> +echo -e "Test redirect direcotry: $RESULT" >> $RESOULT_FILE
>>> +
>>> +echo "***************"
>>> diff --git a/test/clean.sh b/test/clean.sh
>>> new file mode 100755
>>> index 0000000..80f360b
>>> --- /dev/null
>>> +++ b/test/clean.sh
>>> @@ -0,0 +1,6 @@
>>> +#!/bin/bash
>>> +
>>> +. ./src/prepare.sh
>>> +
>>> +rm -rf $RESULT_DIR
>>> +rm -rf $TEST_DIR
>>> diff --git a/test/local.config b/test/local.config
>>> new file mode 100644
>>> index 0000000..990395f
>>> --- /dev/null
>>> +++ b/test/local.config
>>> @@ -0,0 +1,16 @@
>>> +# Config
>>> +export OVL_FSCK=fsck.overlay
>>> +export TEST_DIR=/mnt/test
>>> +
>>> +# Base environment
>>> +export PWD=`pwd`
>>> +export RESULT_DIR=$PWD/result
>>> +export SOURCE_DIR=$PWD/src
>>> +
>>> +# Overlayfs config
>>> +export LOWER_DIR="lower"
>>> +export UPPER_DIR="upper"
>>> +export WORK_DIR="worker"
>>
>> worker? this is a strange name for work dir location..
>> it does not have the same meaning in English as upp-er and low-er.
>>
>>> +export MERGE_DIR="merge"
>>> +export LOWER_DIR1="lower1"
>>> +export WORK_DIR1="worker1"
>>> diff --git a/test/src/opaque_test.sh b/test/src/opaque_test.sh
>>> new file mode 100755
>>> index 0000000..7cb5030
>>> --- /dev/null
>>> +++ b/test/src/opaque_test.sh
>>> @@ -0,0 +1,144 @@
>>> +#!/bin/bash
>>> +
>>> +. ./local.config
>>> +
>>> +__clean()
>>> +{
>>> +       rm -rf $TEST_DIR/*
>>> +       cd $PWD
>>> +}
>>> +
>>> +OVL_OPAQUE_XATTR="trusted.overlay.opaque"
>>> +OVL_OPAQUE_XATTR_VAL="y"
>>> +RET=0
>>> +
>>> +cd $TEST_DIR
>>> +rm -rf *
>>> +mkdir $LOWER_DIR $LOWER_DIR1 $UPPER_DIR $WORK_DIR
>>> +
>>> +# 1.Test lower invalid opaque directory
>>> +echo "***** 1.Test lower invalid opaque directory *****"
>>> +mkdir $LOWER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: lower's invalid opaque xattr not remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 2.Test upper invalid opaque directory
>>> +echo "***** 2.Test upper invalid opaque directory *****"
>>> +mkdir -p $UPPER_DIR/testdir0/testdir1
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir0/testdir1
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir0/testdir1
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: upper's invalid opaque xattr not remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +
>>> +# 3.Test upper opaque direcotry in merged directory
>>> +echo "***** 3.Test upper opaque direcotry in merged directory *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's opaque xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +
>>> +# 4.Test upper opaque direcotry cover lower file
>>> +echo "***** 4.Test upper opaque direcotry cover lower file *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +mkdir $LOWER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's opaque xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 5.Test upper opaque direcotry cover lower directory
>>> +echo "***** 5.Test upper opaque direcotry cover lower directory *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +touch $LOWER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's opaque xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 6.Test lower invalid opaque directory in middle layer
>>> +echo "***** 6.Test lower invalid opaque directory in middle layer *****"
>>> +mkdir $LOWER_DIR/testdir0/testdir1
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir0/testdir1
>>> +$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir0/testdir1
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: middle's opaque xattr not removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 7.Test lower invalid opaque directory in bottom layer
>>> +echo "***** 7.Test lower invalid opaque directory in bottom layer *****"
>>> +mkdir $LOWER_DIR1/testdir0/testdir1
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR1/testdir0/
>>> +$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR1/testdir0/testdir1
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: middle's opaque xattr not removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $LOWER_DIR1/*
>>> +
>>> +# 8.Test middle opaque direcotry cover bottom directory
>>> +echo "***** 8.Test middle opaque direcotry cover bottom directory *****"
>>> +mkdir $LOWER_DIR1/testdir
>>> +mkdir $LOWER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: middle's opaque xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $LOWER_DIR1/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 9.Test double opaque direcotry in middle and upper layer
>>> +echo "***** 9.Test double opaque direcotry in middle and upper layer *****"
>>> +mkdir $LOWER_DIR1/testdir
>>> +mkdir $LOWER_DIR/testdir
>>> +mkdir $UPPER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir
>>> +setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: middle's opaque xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's opaque xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $LOWER_DIR1/*
>>> +rm -rf $LOWER_DIR/*
>>> +rm -rf $UPPER_DIR/*
>>> +
>>> +__clean
>>> +exit $RET
>>> diff --git a/test/src/prepare.sh b/test/src/prepare.sh
>>> new file mode 100755
>>> index 0000000..138539a
>>> --- /dev/null
>>> +++ b/test/src/prepare.sh
>>> @@ -0,0 +1,15 @@
>>> +#!/bin/bash
>>> +
>>> +. ./local.config
>>> +
>>> +NOW=`date +"%Y-%m-%d-%H-%M-%S"`
>>> +LOG_FILE=$RESULT_DIR/LOG_${NOW}.log
>>> +RESOULT_FILE=$RESULT_DIR/RESULT_${NOW}.out
>>> +
>>> +# creat test base dir
>>> +if [ ! -d "$TEST_DIR" ]; then
>>> +       mkdir -p $TEST_DIR
>>> +fi
>>> +
>>> +# creat result dir
>>> +mkdir -p $RESULT_DIR
>>> diff --git a/test/src/redirect_test.sh b/test/src/redirect_test.sh
>>> new file mode 100755
>>> index 0000000..be2ce80
>>> --- /dev/null
>>> +++ b/test/src/redirect_test.sh
>>> @@ -0,0 +1,163 @@
>>> +#!/bin/bash
>>> +
>>> +. ./local.config
>>> +
>>> +__clean()
>>> +{
>>> +       rm -rf $TEST_DIR/*
>>> +       cd $PWD
>>> +}
>>> +
>>> +OVL_REDIRECT_XATTR="trusted.overlay.redirect"
>>> +OVL_OPAQUE_XATTR="trusted.overlay.opaque"
>>> +RET=0
>>> +
>>> +cd $TEST_DIR
>>> +rm -rf *
>>> +mkdir $LOWER_DIR $LOWER_DIR1 $UPPER_DIR $WORK_DIR
>>> +
>>> +# 1.Test no exist redirect origin
>>> +echo "***** 1.Test no exist redirect origin *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "xxx" $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr not remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +
>>> +# 2.Test redirect origin is file
>>> +echo "***** 2.Test redirect origin is file *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +touch $LOWER_DIR/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr not remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 3.Test valid redirect xattr
>>> +echo "***** 3.Test valid redirect xattr *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +mknod $UPPER_DIR/origin c 0 0
>>> +mkdir $LOWER_DIR/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 4.Test valid redirect xattr start from root
>>> +echo "***** 4.Test valid redirect xattr start from root *****"
>>> +mkdir -p $UPPER_DIR/testdir0/testdir1
>>> +mknod $UPPER_DIR/origin c 0 0
>>> +mkdir $LOWER_DIR/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "/origin" $UPPER_DIR/testdir0/testdir1
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir0/testdir1
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 5.Test missing whiteout in redirect parent directory
>>> +echo "***** 5.Test missing whiteout in redirect parent directory *****"
>>> +mkdir $UPPER_DIR/testdir
>>> +mkdir $LOWER_DIR/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +if [ ! -e "$UPPER_DIR/origin" ];then
>>> +       echo "ERROR: upper's missing whiteout not create"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $UPPER_DIR/*
>>> +
>>> +# 6.Test missing opaque in redirect parent directory
>>> +echo "***** 6.Test missing opaque in redirect parent directory *****"
>>> +mkdir -p $UPPER_DIR/testdir0/testdir1
>>> +mkdir $UPPER_DIR/origin
>>> +mkdir $LOWER_DIR/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "/origin" $UPPER_DIR/testdir0/testdir1
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir0/testdir1
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/origin
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's missing opaque not set"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 7.Test duplicate redirect directory in one layer
>>> +echo "***** 7.Test duplicate redirect directory in one layer *****"
>>> +mkdir $UPPER_DIR/testdir0
>>> +mkdir $UPPER_DIR/testdir1
>>> +mknod $UPPER_DIR/origin c 0 0
>>> +mkdir $LOWER_DIR/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir0
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir1
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +if [[ $? -eq 0 ]];then
>>> +       echo "ERROR: fsck check incorrect pass"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +
>>> +# 8.Test duplicate redirect directory in different layer
>>> +echo "***** 8.Test duplicate redirect directory in different layer *****"
>>> +mkdir $UPPER_DIR/testdir0
>>> +mkdir $LOWER_DIR/testdir1
>>> +mkdir $LOWER_DIR1/origin
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir0
>>> +setfattr -n $OVL_REDIRECT_XATTR -v "origin" $LOWER_DIR/testdir1
>>> +$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
>>> +getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir0
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: upper's redirect xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +getfattr -n $OVL_REDIRECT_XATTR $LOWER_DIR/testdir1
>>> +if [[ $? -ne 0 ]];then
>>> +       echo "ERROR: lower's redirect xattr incorrect removed"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +
>>> +if [ ! -e "$LOWER_DIR/origin" ];then
>>> +       echo "ERROR: upper's missing whiteout not create"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +if [ ! -e "$LOWER_DIR/origin" ];then
>>> +       echo "ERROR: lower's missing whiteout not create"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +
>>> +rm -rf $UPPER_DIR/*
>>> +rm -rf $LOWER_DIR/*
>>> +rm -rf $LOWER_DIR1/*
>>> +
>>> +__clean
>>> +
>>> +exit $RET
>>> diff --git a/test/src/whiteout_test.sh b/test/src/whiteout_test.sh
>>> new file mode 100755
>>> index 0000000..c0e1555
>>> --- /dev/null
>>> +++ b/test/src/whiteout_test.sh
>>> @@ -0,0 +1,63 @@
>>> +#!/bin/bash
>>> +
>>> +. ./local.config
>>> +
>>> +__clean()
>>> +{
>>> +       rm -rf $TEST_DIR/*
>>> +       cd $PWD
>>> +}
>>> +
>>> +RET=0
>>> +
>>> +cd $TEST_DIR
>>> +rm -rf *
>>> +mkdir $LOWER_DIR $LOWER_DIR1 $UPPER_DIR $WORK_DIR
>>> +
>>> +# 1.Test lower orphan whiteout
>>> +echo "***** 1.Test lower orphan whiteout *****"
>>> +mknod $LOWER_DIR/foo c 0 0
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +if [ -e "$LOWER_DIR/foo" ];then
>>> +       echo "lower's whiteout not remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -f $LOWER_DIR/*
>>> +
>>> +# 2.Test upper orphan whiteout
>>> +echo "***** 2.Test upper orphan whiteout *****"
>>> +mknod $UPPER_DIR/foo c 0 0
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +if [ -e "$UPPER_DIR/foo" ];then
>>> +       echo "upper's whiteout not remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -f $UPPER_DIR/*
>>> +
>>> +# 3.Test upper inuse whiteout
>>> +echo "***** 3.Test upper inuse whiteout *****"
>>> +touch $LOWER_DIR/foo
>>> +mknod $UPPER_DIR/foo c 0 0
>>> +$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +if [ ! -e "$UPPER_DIR/foo" ];then
>>> +       echo "upper's whiteout incorrect remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -f $UPPER_DIR/*
>>> +rm -f $LOWER_DIR/*
>>> +
>>> +# 4.Test lower inuse whiteout
>>> +echo "***** 4.Test lower inuse whiteout *****"
>>> +touch $LOWER_DIR/foo
>>> +mknod $LOWER_DIR1/foo c 0 0
>>> +$OVL_FSCK -a -l $LOWER_DIR1:$LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
>>> +if [ ! -e "$LOWER_DIR1/foo" ];then
>>> +       echo "lower's whiteout incorrect remove"
>>> +       RET=$(($RET+1))
>>> +fi
>>> +rm -f $LOWER_DIR1/*
>>> +rm -f $LOWER_DIR/*
>>> +
>>> +__clean
>>> +
>>> +exit $RET
>>> --
>>> 2.9.5
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 
