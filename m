From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] overlay: Clear stale ->numlower state over rename operation
Date: Sat, 30 Jan 2016 00:30:16 +0300
Message-ID: <CALYGNiODnRZ5HMwdrFamLdhG+NE9y0G2L_ttyEZZwSijMZ65_A@mail.gmail.com>
References: <20160125215832.GB8948@redhat.com>
	<CALYGNiNntf1XvqL54hBgwCwFZEAsUEGmMDa-UW4JOi5X1Ba=jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34621 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbcA2VaS (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 29 Jan 2016 16:30:18 -0500
In-Reply-To: <CALYGNiNntf1XvqL54hBgwCwFZEAsUEGmMDa-UW4JOi5X1Ba=jA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 29, 2016 at 11:26 PM, Konstantin Khlebnikov
<koct9i@gmail.com> wrote:
> On Tue, Jan 26, 2016 at 12:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Over rename, we don't seem to be doing anything about the ->numlower
>> state of ovl_entry and we continue to retain that. Fact of the matter
>> is that ->numlower is not valid any more and it can interfere with
>> other operations like file removal. So reset that state.
>>
>> This fixes the issue reported here.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=109611
>>
>> A previous attempt to fix the issue was here.
>>
>> http://marc.info/?l=linux-fsdevel&m=145252052703010&w=2
>>
>> This probably is better fix than previous one.
>>
>> Here are the details of the problem. Do following.
>>
>> $ mkdir upper lower work merged upper/dir/
>> $ touch lower/test
>> $ sudo mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
>> merged
>> $ mv merged/test merged/dir/
>> $ rm merged/dir/test
>> $ ls -l merged/dir/
>> /usr/bin/ls: cannot access merged/dir/test: No such file or directory
>> total 0
>> c????????? ? ? ? ?            ? test
>>
>> Basic problem seems to be that once a file has been unlinked, a
>> whiteout has been left behind which was not needed and hence it becomes
>> visible.
>>
>> whiteout is visible because parent dir is of not type MERGE, hence
>> od->is_real is set during ovl_dir_open(). And that means ovl_iterate()
>> passes on iterate handling directly to underlying fs. Underlying fs does
>> not know/filter whiteouts so it becomes visible to user.
>>
>> Why did we leave a whiteout to begin with when we should not have.
>> ovl_do_remove() checks for OVL_TYPE_PURE_UPPER() and does not leave
>> whiteout if file is pure upper. In this case file is not found to be
>> pure upper hence whiteout is left.
>>
>> So why file was not PURE_UPPER in this case? I think because dentry is
>> still carrying some leftover state which was valid before rename. For example,
>> od->numlower was set to 1 as it was a lower file. After rename, this state
>> is not valid anymore as there is no such file in lower.
>
> I've stumbled upon the same bug.
>
> I'm affraid this solution is racy: ovl_path_real() works without any locks.
> __upperdentry could appear at any time, but lowerstack[0] cannot disapper.
>
> I thiink the only option is keeping 'purity' status in ovl_entry independently.
> Or better call is 'haslower'. It could differ from numlower !=0 for file entries
> with upper dentry. After copy_up and rename entrly will keep references to
> lower dentry from old location but haslower will be copied from entry from
> new location.

Or just use 'opaque' for that. As I see it already means exactly what needed.

This should be enough, untested though.

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -76,12 +76,10 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
        if (oe->__upperdentry) {
                type = __OVL_PATH_UPPER;

-               if (oe->numlower) {
-                       if (S_ISDIR(dentry->d_inode->i_mode))
-                               type |= __OVL_PATH_MERGE;
-               } else if (!oe->opaque) {
+               if (S_ISDIR(dentry->d_inode->i_mode) && oe->numlower)
+                       type |= __OVL_PATH_MERGE;
+               else if (!oe->opaque)
                        type |= __OVL_PATH_PURE;
-               }
        } else {
                if (oe->numlower > 1)
                        type |= __OVL_PATH_MERGE;


>
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> ---
>>  fs/overlayfs/dir.c       | 13 +++++++++++++
>>  fs/overlayfs/overlayfs.h |  1 +
>>  fs/overlayfs/super.c     | 13 +++++++++++++
>>  3 files changed, 27 insertions(+)
>>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index 692ceda..a165213 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -909,6 +909,19 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
>>                         ovl_dentry_set_opaque(new, old_opaque);
>>         }
>>
>> +       /*
>> +        * As file/dir is being renamed, ->numlower state is stale. It
>> +        * should be ok to set it to zero as at new location file will
>> +        * be either upper/pure_upper and numlower will be zero. In
>> +        * case of directory, if destination dir is present it has to be
>> +        * empty dir and rename should be overwriting that directory and
>> +        * that should make lower level direcotry invisible hence
>> +        * numlower=0 makes sense there too.
>> +        */
>> +       ovl_free_lower(old);
>> +       if (!overwrite)
>> +               ovl_free_lower(new);
>> +
>>         if (cleanup_whiteout)
>>                 ovl_cleanup(old_upperdir->d_inode, newdentry);
>>
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index e17154a..d75b6a0 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -151,6 +151,7 @@ bool ovl_dentry_is_opaque(struct dentry *dentry);
>>  void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque);
>>  bool ovl_is_whiteout(struct dentry *dentry);
>>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
>> +void ovl_free_lower(struct dentry *dentry);
>>  struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>                           unsigned int flags);
>>  struct file *ovl_path_open(struct path *path, int flags);
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index e38ee0f..31f9920 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -205,6 +205,19 @@ void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque)
>>         oe->opaque = opaque;
>>  }
>>
>> +void ovl_free_lower(struct dentry *dentry) {
>> +       struct ovl_entry *oe = dentry->d_fsdata;
>> +       int i;
>> +
>> +       if (!oe->numlower)
>> +               return;
>> +
>> +       for (i = 0; i < oe->numlower; i++)
>> +               dput(oe->lowerstack[i].dentry);
>> +
>> +       oe->numlower = 0;
>> +}
>> +
>>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
>>  {
>>         struct ovl_entry *oe = dentry->d_fsdata;
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
