Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvAx1yNkDJNcCa-YZOCpz1OgeWK8SE341-iE8L5E8wsKw@mail.gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
 <1526632177-28832-10-git-send-email-amir73il@gmail.com> <20180518150353.GS30522@ZenIV.linux.org.uk>
 <CAJfpegvAx1yNkDJNcCa-YZOCpz1OgeWK8SE341-iE8L5E8wsKw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 18 May 2018 18:36:51 +0300
Message-ID: <CAOQ4uxg54AedZZtDpkGrinUcOt9kiKoG2s9+RAjz0f+2CGVPrg@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] ovl: use iget5_prealloc() to hash a newly created inode
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 18, 2018 at 6:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, May 18, 2018 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Fri, May 18, 2018 at 11:29:37AM +0300, Amir Goldstein wrote:
>>> Currently, there is a small window where ovl_obtain_alias() can
>>> race with ovl_instantiate() and create two different overlay inodes
>>> with the same underlying real non-dir non-hardlink inode.
>>>
>>> The race requires an adversary to guess the file handle of the
>>> yet to be created upper inode and decode the guessed file handle
>>> after ovl_creat_real(), but before ovl_instantiate().
>>> This race does not affect overlay directory inodes, because those
>>> are decoded via ovl_lookup_real() and not with ovl_obtain_alias().
>>>
>>> This patch fixes the race, by using iget5_prealloc() to add a newly
>>> created inode to cache.
>>
>> Mind explaining what the hell is wrong with insert_inode_locked4()?
>
> That it doesn't return the old inode if found.
>

FYI, I have set a side a version I was working on before iget5_prealloc()
that uses insert_inode_locked5 (runner up for ugliest function name):

+int insert_inode_locked4(struct inode *inode, unsigned long hashval,
+               int (*test)(struct inode *, void *), void *data)
+{
+       struct inode *old = insert_inode_locked5(inode, hashval, test, data);

+       if (old) {
+               iput(old);
+               return -EBUSY;
+       }
+
+       return 0;
+}
+EXPORT_SYMBOL(insert_inode_locked4);

Let me know if you want me to resurrect it.

Thanks,
Amir.



> Btw, these functions are eerily similar, and it'd be nice to reduce
> the number of them.
>
> Thanks,
> Miklos
