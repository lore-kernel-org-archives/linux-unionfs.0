MIME-Version: 1.0
In-Reply-To: <20180518154042.GT30522@ZenIV.linux.org.uk>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
	<1526632177-28832-10-git-send-email-amir73il@gmail.com>
	<20180518150353.GS30522@ZenIV.linux.org.uk>
	<CAJfpegvAx1yNkDJNcCa-YZOCpz1OgeWK8SE341-iE8L5E8wsKw@mail.gmail.com>
	<20180518154042.GT30522@ZenIV.linux.org.uk>
Date: Fri, 18 May 2018 18:01:22 +0200
Message-ID: <CAJfpegt1K0qYcZrws+MnhXr54=8DEG3KbpzaGg-ePOqDPkSMSQ@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] ovl: use iget5_prealloc() to hash a newly created inode
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 18, 2018 at 5:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, May 18, 2018 at 05:11:20PM +0200, Miklos Szeredi wrote:
>> On Fri, May 18, 2018 at 5:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Fri, May 18, 2018 at 11:29:37AM +0300, Amir Goldstein wrote:
>> >> Currently, there is a small window where ovl_obtain_alias() can
>> >> race with ovl_instantiate() and create two different overlay inodes
>> >> with the same underlying real non-dir non-hardlink inode.
>> >>
>> >> The race requires an adversary to guess the file handle of the
>> >> yet to be created upper inode and decode the guessed file handle
>> >> after ovl_creat_real(), but before ovl_instantiate().
>> >> This race does not affect overlay directory inodes, because those
>> >> are decoded via ovl_lookup_real() and not with ovl_obtain_alias().
>> >>
>> >> This patch fixes the race, by using iget5_prealloc() to add a newly
>> >> created inode to cache.
>> >
>> > Mind explaining what the hell is wrong with insert_inode_locked4()?
>>
>> That it doesn't return the old inode if found.
>>
>> Btw, these functions are eerily similar, and it'd be nice to reduce
>> the number of them.
>
> IMO you are using the wrong model; just create the underlying object,
> then do what lookup would for overlayfs inode creation, then
> d_splice_alias() + dput() of return value (if non-IS_ERR).

That's fine.  Issue is with inode allocation.  I'd really like to
avoid dealing with failure after a successful create.  Doing the
iget5_locked() can fail with -ENOMEM, altough it's arguably a rare
occurrence.

Thanks,
Miklos
