From: Rock Lee <rockdotlee@gmail.com>
Subject: Re: [PATCH] ovl: fix dir cache leak for ovl_cache_get
Date: Mon, 8 May 2017 17:54:54 +0800
Message-ID: <CAL-1w2uu3b2Cc5cvrJEC5Wd2HzSEKkDGUR=vztL2VdAFamVJuQ@mail.gmail.com>
References: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com>
 <CAOQ4uxinf7VO+=LnUkBjgCAQvUB-4nwP6vMPM4Orcq2FvgQdKg@mail.gmail.com>
 <CAL-1w2tQmJFxu+72wkKu9wZznx0wE-UX24cFzCG=3XfEY4PETQ@mail.gmail.com> <CAOQ4uxginvgDYQD+ijXSeU+EbDTV6+Q2OH3MP6kvN-0aY6XNdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:35075 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754097AbdEHJy4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 May 2017 05:54:56 -0400
Received: by mail-yb0-f196.google.com with SMTP id 19so1856970ybl.2
        for <linux-unionfs@vger.kernel.org>; Mon, 08 May 2017 02:54:55 -0700 (PDT)
In-Reply-To: <CAOQ4uxginvgDYQD+ijXSeU+EbDTV6+Q2OH3MP6kvN-0aY6XNdA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Sun, May 7, 2017 at 7:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, May 5, 2017 at 9:34 AM, Rock Lee <rockdotlee@gmail.com> wrote:
>> Hi, Amir:
>>
>>> This is not a leak. dir cache is refcounted and freed on
>>> ovl_dir_{release|reset}() -> ovl_cache_put()
>>
>> Here is the snippet:
>>
>> if (cache && ovl_dentry_version_get(dentry) == cache->version) {
>> cache->refcount++;
>> return cache;
>> }
>>
>> ovl_set_dir_cache(dentry, NULL);
>>
>> I am a little confused here. From the logic of the code, there must
>> have a circumstance --- cache is not NULL and
>> ovl_dentry_version_get(dentry) != cache->version. If
>> ovl_set_dir_cache(dentry, NULL), we can't find the old dir cache  form
>> dentry and struct file(later, file->private_data->cache will point at
>> the same dir cache with dentry). How could we free it in
>> ovl_dir_{release|reset} ?
>>
>
> It has a reference from another struct file, not this one
> and cache will be freed when the last file that references it
> is closed:
>
> static int ovl_dir_release(struct inode *inode, struct file *file)
> {
>         struct ovl_dir_file *od = file->private_data;
>
>         if (od->cache) {
>                 inode_lock(inode);
>                 ovl_cache_put(od, file->f_path.dentry);
>                 inode_unlock(inode);
>         }
>
>> BTW, could you please an example when ovl_dentry_version_get(dentry)
>> != cache->version in ovl_cache_get ?
>>
>
> In theory (didn't try this code):
>
> d1 = opendir("foo");
> readdir(d1); /* populate d1's od->cache and read first entry */
> pos = telldir(d1);
> creat("foo/bar", 0600); /* ovl_dentry_version_inc() */
> d2 = opendir("foo");
> seekdir(d2, pos);
> readdir(d2); /* populate d2's od->cache and read second entry */
>
> d2's od->cache is NULL, ctx->pos = 1, and ovl_get_cache() will
> find that ovl_dir_cache() is out dated and will create a new cache,
> which should contain the new file "bar".

Thanks for your explaination, I leaned a lot. I have tested your code,
and it met your expectation ;-).

One more question, only ctx->pos == 0 in ovl_iterate would cause
ovl_dir_reset and rebuild dir cache which means in some scenarios, dir
cache may be not up to date. Consider this code:

    DIR *dirp = opendir("foo");
    readdir(dirp);                /* make sure ctx->pos != 0 in the
blow readir() */
    creat("foo/bar" ,0600);  /* ovl_dentry_version_inc() */
    while ((entry = readdir(dirp)) != NULL) {
        printf("name %s\n", entry->d_name);
    }

In this case, "foo/bar" will not be shown in the output because
readdir will not rebuild dir cache. Could we just ovl_dir_reset()
everytime regardless of ctx->pos in ovl_iterate() ? Once files
created/removed/renamed in a directory, ovl_iterate will rebuild dir
cache and keep the dir cache up to date?

-- 
Cheers,
Rock
