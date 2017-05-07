From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix dir cache leak for ovl_cache_get
Date: Sun, 7 May 2017 14:34:30 +0300
Message-ID: <CAOQ4uxginvgDYQD+ijXSeU+EbDTV6+Q2OH3MP6kvN-0aY6XNdA@mail.gmail.com>
References: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com>
 <CAOQ4uxinf7VO+=LnUkBjgCAQvUB-4nwP6vMPM4Orcq2FvgQdKg@mail.gmail.com> <CAL-1w2tQmJFxu+72wkKu9wZznx0wE-UX24cFzCG=3XfEY4PETQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35100 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754427AbdEGWZ7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 7 May 2017 18:25:59 -0400
Received: by mail-oi0-f51.google.com with SMTP id l18so32938110oig.2
        for <linux-unionfs@vger.kernel.org>; Sun, 07 May 2017 15:25:58 -0700 (PDT)
In-Reply-To: <CAL-1w2tQmJFxu+72wkKu9wZznx0wE-UX24cFzCG=3XfEY4PETQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Fri, May 5, 2017 at 9:34 AM, Rock Lee <rockdotlee@gmail.com> wrote:
> Hi, Amir:
>
>> This is not a leak. dir cache is refcounted and freed on
>> ovl_dir_{release|reset}() -> ovl_cache_put()
>
> Here is the snippet:
>
> if (cache && ovl_dentry_version_get(dentry) == cache->version) {
> cache->refcount++;
> return cache;
> }
>
> ovl_set_dir_cache(dentry, NULL);
>
> I am a little confused here. From the logic of the code, there must
> have a circumstance --- cache is not NULL and
> ovl_dentry_version_get(dentry) != cache->version. If
> ovl_set_dir_cache(dentry, NULL), we can't find the old dir cache  form
> dentry and struct file(later, file->private_data->cache will point at
> the same dir cache with dentry). How could we free it in
> ovl_dir_{release|reset} ?
>

It has a reference from another struct file, not this one
and cache will be freed when the last file that references it
is closed:

static int ovl_dir_release(struct inode *inode, struct file *file)
{
        struct ovl_dir_file *od = file->private_data;

        if (od->cache) {
                inode_lock(inode);
                ovl_cache_put(od, file->f_path.dentry);
                inode_unlock(inode);
        }

> BTW, could you please an example when ovl_dentry_version_get(dentry)
> != cache->version in ovl_cache_get ?
>

In theory (didn't try this code):

d1 = opendir("foo");
readdir(d1); /* populate d1's od->cache and read first entry */
pos = telldir(d1);
creat("foo/bar", 0600); /* ovl_dentry_version_inc() */
d2 = opendir("foo");
seekdir(d2, pos);
readdir(d2); /* populate d2's od->cache and read second entry */

d2's od->cache is NULL, ctx->pos = 1, and ovl_get_cache() will
find that ovl_dir_cache() is out dated and will create a new cache,
which should contain the new file "bar".

Amir.
