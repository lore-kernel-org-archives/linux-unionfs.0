Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegsP-GrgenqRcc9-YrHHxWrtq1ApswD=FimUid4-8hXhBg@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-4-git-send-email-amir73il@gmail.com> <CAJfpegsP-GrgenqRcc9-YrHHxWrtq1ApswD=FimUid4-8hXhBg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 16 May 2018 14:15:23 +0300
Message-ID: <CAOQ4uxgOvzFRb1RYSiCEE2Q4dbCCTaywi8b+kRmJOp7gUeB2-w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: create helper ovl_create_temp()
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 16, 2018 at 1:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, May 15, 2018 at 12:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Al Viro suggested to simplify callers of ovl_create_real() by
>> returning the created dentry (or ERR_PTR) from ovl_create_real().
>> This is a spin off of his suggestion, which is cleaner in my opinion.
>>
>> Also created a wrapper ovl_create_temp_dir() and used it in
>> ovl_create_index() instead of calling ovl_do_mkdir(), so now all callers
>> of ovl_do_mkdir() are routed through ovl_create_real(), which paves the
>> way for Al's fix for non-hashed result from vfs_mkdir().
>>
>> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/copy_up.c   | 27 +++++++--------------------
>>  fs/overlayfs/dir.c       | 47 +++++++++++++++++++++++++++++------------------
>>  fs/overlayfs/overlayfs.h |  9 ++++++++-
>>  3 files changed, 44 insertions(+), 39 deletions(-)
>>
>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> index 8bede0742619..4ba16cbeaec2 100644
>> --- a/fs/overlayfs/copy_up.c
>> +++ b/fs/overlayfs/copy_up.c
>> @@ -365,14 +365,10 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
>>         if (err)
>>                 return err;
>>
>> -       temp = ovl_lookup_temp(indexdir);
>> +       temp = ovl_create_temp_dir(indexdir);
>
> #define OVL_DIR_CATTR(m) (&(struct cattr) { .mode = S_IFDIR | (m) })
>         temp = ovl_create_temp(indexdir, OVL_DIR_CATTR(0), NULL);
>

OK.

>>         if (IS_ERR(temp))
>>                 goto temp_err;
>>
>> -       err = ovl_do_mkdir(dir, temp, S_IFDIR, true);
>> -       if (err)
>> -               goto out;
>> -
>>         err = ovl_set_upper_fh(upper, temp);
>>         if (err)
>>                 goto out_cleanup;
>> @@ -501,22 +497,13 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
>>         if (new_creds)
>>                 old_creds = override_creds(new_creds);
>>
>> -       if (c->tmpfile) {
>> +       if (c->tmpfile)
>>                 temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
>> -               if (IS_ERR(temp))
>> -                       goto temp_err;
>> -       } else {
>> -               temp = ovl_lookup_temp(c->workdir);
>> -               if (IS_ERR(temp))
>> -                       goto temp_err;
>> -
>> -               err = ovl_create_real(d_inode(c->workdir), temp, &cattr,
>> -                                     NULL, true);
>> -               if (err) {
>> -                       dput(temp);
>> -                       goto out;
>> -               }
>> -       }
>> +       else
>> +               temp = ovl_create_temp(c->workdir, &cattr, NULL);
>> +       if (IS_ERR(temp))
>> +               goto temp_err;
>> +
>>         err = 0;
>>         *tempp = temp;
>>  out:
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index 25b339278684..45f5f9232e71 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -160,6 +160,26 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
>>         return err;
>>  }
>>
>> +struct dentry *ovl_create_temp(struct dentry *workdir, struct cattr *attr,
>> +                              struct dentry *hardlink)
>
> Talking of cleanups, can we put hardlink into cattr as well?  (separate patch)
>

OK. If you don't mind, I'll use this opportunity to also namespace
it to ovl_cattr.

>> +{
>> +       struct inode *wdir = workdir->d_inode;
>> +       struct dentry *temp;
>> +       int err;
>> +
>> +       temp = ovl_lookup_temp(workdir);
>> +       if (IS_ERR(temp))
>> +               return temp;
>
> What's wrong with viro's version of  dentry in ovl_create_real()?
> Turns this whole function into:
>
>         return ovl_create_real(d_inode(workdir),
> ovl_lookup_temp(workdir), attr, hardlink, true);

Nothing. A matter of taste. If you like Al's version better,
I'll add it back in the next patch.

>
>> +
>> +       err = ovl_create_real(wdir, temp, attr, hardlink, true);
>> +       if (err) {
>> +               dput(temp);
>> +               return ERR_PTR(err);
>> +       }
>> +
>> +       return temp;
>> +}
>> +
>>  static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
>>                                int xerr)
>>  {
>> @@ -292,15 +312,11 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
>>         if (upper->d_parent->d_inode != udir)
>>                 goto out_unlock;
>>
>> -       opaquedir = ovl_lookup_temp(workdir);
>> +       opaquedir = ovl_create_temp_dir(workdir);
>
> Where has the mode gone?

OOPS. I'll get it back.

Thanks,
Amir.
