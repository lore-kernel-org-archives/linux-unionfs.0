From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v3 6/6] fsck.overlay: add impure xattr check
Date: Fri, 29 Dec 2017 10:21:27 +0800
Message-ID: <5d420519-f19f-3bc9-eef1-74233c1650d1@huawei.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com>
 <20171228114023.43999-7-yi.zhang@huawei.com>
 <CAOQ4uxjran64YjBvT4mWDsQgDZi+_NnommX2OTP-W1FdVJh75Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751345AbdL2CWf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 21:22:35 -0500
In-Reply-To: <CAOQ4uxjran64YjBvT4mWDsQgDZi+_NnommX2OTP-W1FdVJh75Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On 2017/12/28 21:18, Amir Goldstein Wrote:
> On Thu, Dec 28, 2017 at 1:40 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> An impure directory is a directory with "trusted.overlay.impure" xattr
>> valued 'y', which indicate that this directory may contain copy-uped
>> targets from lower layers. In oredr to prevent 'd_ino' change while
>> copy-up (it create a new inode in upper layer) in getdents(2), impure
>> xattr will be set in the parent directory, letting overlay filesystem
>> check and get d_ino from lower origin target to ensure consistent d_ino.
>>
>> There are three situations of setting impure xattr:
>> 1) Copyup lower target in a directory.
>> 2) Link an origined target (already copy-uped, have origin xattr) into
>>    a directory.
>> 3) Rename an origined target (include merged subdirectories) into a
>>    new directory.
>>
>> So, if a direcotry which contains several origined targets or redirect
>> directories, the impure xattr should be set. If not, fix this xattr.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  README.md | 22 +++++++++++++++-
>>  check.c   | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  lib.c     | 63 +++++++++++++++++++++++++++++++++++-----------
>>  lib.h     | 25 +++++++++++++------
>>  4 files changed, 168 insertions(+), 28 deletions(-)
>>
>> diff --git a/README.md b/README.md
>> index 2e6146f..cdbd382 100644
>> --- a/README.md
>> +++ b/README.md
>> @@ -47,6 +47,26 @@ If an invalid redirect xattr was removed by fsck and there is a corresponding
>>  lower directory with the same name exists, not sure this directory is merged
>>  or not, ask user to make a decision.
>>
>> +Impure directories
>> +------------------
>> +
>> +An impure directory is a directory with "trusted.overlay.impure" xattr valued
>> +'y', which indicate that this directory may contain copy-uped targets from lower
> 
> "copied up"
> 
>> +layers. In oredr to prevent 'd_ino' change while copy-up (it create a new
> 
> typo: oredr/order
> 
>> +inode in upper layer) in getdents (see getdents(2)), impure xattr will be set
>> +in the parent directory, letting overlay filesystem check and get d_ino from
>> +lower origin target to ensure consistent d_ino.
>> +
> 
> This paragraph could use a review from a native English speaker (not me)
> 
Sorry, my fault, will reorganize this document and fix typo.

>> +There are three situations of setting impure xattr:
>> +1) Copyup lower target in a directory.
> 
> I guess the only instance of "copyup" in comment in my blame.
> Either "Copy up" or "Copy-up" would be better and the former is more
> common in comments and documentations.
> 
>> +2) Link an origined target (already copy-uped, have origin xattr) into
> 
> "copied up"
> 
>> +   a directory.
>> +3) Rename an origined target (include merged subdirectories) into a
>> +   new directory.
>> +
>> +So, if a direcotry which contains several origined targets or redirect
>> +directories, the impure xattr should be set. If not, fix this xattr.
>> +
>>  Usage
>>  =====
>>
>> @@ -88,6 +108,6 @@ Todo
>>     mounted with relative path. Should modify kernel together to support.
>>  2. Check and fix invalid redirect xattr through origin xattr.
>>  3. Symbolic link check.
>> -4. Check origin/impure/nlink xattr.
>> +4. Check origin/nlink xattr.
>>  5. Check index feature consistency.
>>  6. ...
>> diff --git a/check.c b/check.c
>> index 033d4ba..05293c5 100644
>> --- a/check.c
>> +++ b/check.c
>> @@ -111,9 +111,9 @@ static inline bool ovl_is_opaque(const char *pathname)
>>         return is_dir_xattr(pathname, OVL_OPAQUE_XATTR);
>>  }
>>
>> -static inline int ovl_remove_opaque(const char *pathname)
>> +static inline bool ovl_is_impure(const char *pathname)
>>  {
>> -       return remove_xattr(pathname, OVL_OPAQUE_XATTR);
>> +       return is_dir_xattr(pathname, OVL_IMPURE_XATTR);
>>  }
>>
>>  static inline int ovl_set_opaque(const char *pathname)
>> @@ -121,6 +121,11 @@ static inline int ovl_set_opaque(const char *pathname)
>>         return set_xattr(pathname, OVL_OPAQUE_XATTR, "y", 1);
>>  }
>>
>> +static inline int ovl_set_impure(const char *pathname)
>> +{
>> +       return set_xattr(pathname, OVL_IMPURE_XATTR, "y", 1);
>> +}
>> +
>>  static int ovl_get_redirect(const char *pathname, size_t dirlen,
>>                             size_t filelen, char **redirect)
>>  {
>> @@ -166,11 +171,20 @@ static inline int ovl_create_whiteout(const char *pathname)
>>
>>  static inline bool ovl_is_redirect(const char *pathname)
>>  {
>> -       bool exist = false;
>> -       ssize_t ret;
>> +       bool exist = false;
>> +       ssize_t ret;
>> +
>> +       ret = get_xattr(pathname, OVL_REDIRECT_XATTR, NULL, &exist);
>> +       return ret ? false : exist;
>> +}
>> +
>> +static inline bool ovl_is_origin(const char *pathname)
>> +{
>> +       bool exist = false;
>> +       ssize_t ret;
>>
> 
> That's a strange diff... I guess it is a hint from git diff that you
> could factor out
> ovl_is_dir_xattr_exists()
> 
This is because I change blank to tab in ovl_is_redirect(), factor out
ovl_is_dir_xattr_exists() is also fine.

>> -       ret = get_xattr(pathname, OVL_REDIRECT_XATTR, NULL, &exist);
>> -       return ret ? false : exist;
>> +       ret = get_xattr(pathname, OVL_ORIGIN_XATTR, NULL, &exist);
>> +       return ret ? false : exist;
>>  }
>>
>>  static inline int ovl_ask_action(const char *description, const char *pathname,
>> @@ -503,6 +517,7 @@ static void ovl_redirect_free(void)
>>  static int ovl_check_redirect(struct scan_ctx *sctx)
>>  {
>>         const char *pathname = sctx->pathname;
>> +       struct scan_dir_data *parent_ddata = sctx->ddata;
>>         struct ovl_lower_data od = {0};
>>         struct stat cover_st;
>>         bool cover_exist = false;
>> @@ -545,6 +560,9 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
>>                                 goto remove_d;
>>                 }
>>
>> +               /* Now, this redirect xattr is valid */
>> +               if (parent_ddata)
>> +                       parent_ddata->redirects++;
>>                 ovl_redirect_entry_add(pathname, sctx->dirtype,
>>                                        sctx->num, od.path);
>>
>> @@ -603,9 +621,65 @@ out:
>>         return ret;
>>  }
>>
>> +/*
>> + * Get origin xattr stored in the target. We cannot check validity for
>> + * current overlay filesystem, so trust this is valid now.
>> + */
>> +static int ovl_check_origin(struct scan_ctx *sctx)
>> +{
>> +       const char *pathname = sctx->pathname;
>> +       struct scan_dir_data *parent_ddata = sctx->ddata;
>> +
>> +       if (!ovl_is_origin(pathname))
>> +               return 0;
>> +       if (parent_ddata)
>> +               parent_ddata->origins++;
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>> + * If a directory has origined target and redirect subdirectories in it,
>> + * it may contain copy-up targets. In order to avoid 'd_ino' change after
>> + * lower target copyup or renameed (which will create a new inode),
> 
> typo renameed/renamed
> 
>> + * 'impure xattr' will be setted in the parent directory to indicate
> 
> "will be set"
> 
>> + * overlayfs show origin 'd_ino' when iterate directory.
>> + *
>> + * Missing "impure xattr" will cause wrong 'd_ino' in readdir() of impure
>> + * directory, so check origined or redirected target in a directory and
>> + * fix "impure xattr" if necessary.
>> + */
>> +static int ovl_check_impure(struct scan_ctx *sctx)
>> +{
>> +       const char *pathname = sctx->pathname;
>> +       struct scan_dir_data *cur_ddata = sctx->ddata;
>> +       int ret = 0;
>> +
>> +       /*
>> +        * Impure xattr should be set if current directory has redirect
>> +        * directory or origin targets.
>> +        */
>> +       if (!cur_ddata->origins && !cur_ddata->redirects)
>> +               goto out;
>> +
>> +       /* Fix impure xattrs */
>> +       if (!ovl_is_impure(pathname)) {
>> +               if (ovl_ask_action("Missing impure xattr",
>> +                                  pathname, "Fix", 1)) {
>> +                       ret = ovl_set_impure(pathname);
>> +                       if (ret)
>> +                               goto out;
>> +               }
>> +       }
>> +out:
>> +       return ret;
>> +}
>> +
>>  static struct scan_operations ovl_scan_ops = {
>>         .whiteout = ovl_check_whiteout,
>>         .redirect = ovl_check_redirect,
>> +       .origin = ovl_check_origin,
>> +       .impure = ovl_check_impure,
>>  };
>>
>>  static void ovl_scan_report(struct scan_ctx *sctx)
>> diff --git a/lib.c b/lib.c
>> index 497d357..524246d 100644
>> --- a/lib.c
>> +++ b/lib.c
>> @@ -165,8 +165,17 @@ const char *path_pick(const char *path, int baselen)
>>         return (*p == '/') ? p+1 : p;
>>  }
>>
>> -static inline int __check_entry(struct scan_ctx *sctx,
>> -                                 int (*do_check)(struct scan_ctx *))
>> +static void scan_entry_init(struct scan_ctx *sctx, FTSENT *ftsent)
>> +{
>> +       sctx->pathname = ftsent->fts_path;
>> +       sctx->pathlen = ftsent->fts_pathlen;
>> +       sctx->filename = ftsent->fts_name;
>> +       sctx->filelen = ftsent->fts_namelen;
>> +       sctx->st = ftsent->fts_statp;
>> +}
>> +
>> +static inline int scan_check_entry(int (*do_check)(struct scan_ctx *),
>> +                                  struct scan_ctx *sctx)
>>  {
>>         return do_check ? do_check(sctx) : 0;
>>  }
>> @@ -187,8 +196,6 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
>>         }
>>
>>         while ((ftsent = fts_read(ftsp)) != NULL) {
>> -               int err;
>> -
>>                 print_debug(_("Scan:%-3s %2d %7jd   %-40s %s\n"),
>>                         (ftsent->fts_info == FTS_D) ? "d" :
>>                         (ftsent->fts_info == FTS_DNR) ? "dnr" :
>> @@ -202,26 +209,54 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
>>                         ftsent->fts_path, ftsent->fts_name);
>>
>>                 /* Fillup base context */
>> -               sctx->pathname = ftsent->fts_path;
>> -               sctx->pathlen = ftsent->fts_pathlen;
>> -               sctx->filename = ftsent->fts_name;
>> -               sctx->filelen = ftsent->fts_namelen;
>> -               sctx->st = ftsent->fts_statp;
>> +               scan_entry_init(sctx, ftsent);
>>
>>                 switch (ftsent->fts_info) {
>>                 case FTS_F:
>>                         sctx->files++;
>> +
>> +                       /* Check origin */
>> +                       ret = scan_check_entry(sop->origin, sctx);
>> +                       if (ret)
>> +                               goto out;
>>                         break;
>>                 case FTS_DEFAULT:
>>                         /* Check whiteouts */
>> -                       err = __check_entry(sctx, sop->whiteout);
>> -                       ret = (err) ? err : ret;
>> +                       ret = scan_check_entry(sop->whiteout, sctx);
>> +                       if (ret)
>> +                               goto out;
>> +
>> +                       /* Check origin */
>> +                       ret = scan_check_entry(sop->origin, sctx);
>> +                       if (ret)
>> +                               goto out;
> 
> All the re-factoring of scan helpers and this additional origin check
> do not seem relevant to this change's subject (impure dir check).
> 
Current origin check function only count origin targets in a directory
(this function can used for future check). Impure dir check use this
counts to distinguish this directory is impure or not, so this origin
check is necessary in this patch.

Thanks,
Yi.
