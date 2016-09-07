From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs + ubifs: power cut results in "failed to create
 directory /overlay/work/work (errno: 17); mounting read-only"
Date: Wed, 7 Sep 2016 10:28:02 +0200
Message-ID: <CAJfpegv9EwrZJnAi45ck4Cy+UiPQX1L4ztNjdAn-TzGCJqkk7g@mail.gmail.com>
References: <58c7c482-9a51-73d1-7694-e1928f3bedb0@gmail.com>
 <d56ee9a9-5246-a609-b8ca-1c8dee322f46@nod.at> <CAJfpegt_Rw0O7mmP4scNPObAokwiNGs7m9ez1-tmjndOZDMXBg@mail.gmail.com>
 <CACna6rzJi37CYg86YgT+age8ebWX6BtpoEbz7uM18-QiWFvDxQ@mail.gmail.com> <CACna6rwSGU6WLZwVnd+x1iOjHOoNmhrBOCcvS-b1KDXs9gVF0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36802 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754265AbcIGI2D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Sep 2016 04:28:03 -0400
Received: by mail-oi0-f44.google.com with SMTP id w78so15676187oie.3
        for <linux-unionfs@vger.kernel.org>; Wed, 07 Sep 2016 01:28:03 -0700 (PDT)
In-Reply-To: <CACna6rwSGU6WLZwVnd+x1iOjHOoNmhrBOCcvS-b1KDXs9gVF0Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, LEDE Development List <lede-dev@lists.infradead.org>

On Tue, Sep 6, 2016 at 5:53 PM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
> On 6 September 2016 at 14:56, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>> On 6 September 2016 at 14:50, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, Sep 6, 2016 at 1:59 PM, Richard Weinberger <richard@nod.at> wro=
te:
>>>> overlayfs does not issue a recursive rm on workdir, AFAICT you are sup=
posed to cleanup
>>>> workdir yourself before mounting.
>>>> Miklos?
>>>
>>> Fixed in 4.8-rc5 by
>>>
>>> eea2fb4851e9 ("ovl: proper cleanup of workdir")
>>>
>>> I think it's better if kernel does the cleanup, but if it's easier to
>>> upgrade userspace, then that's a valid workaround.
>>
>> Oh, this should solve my problem! It seems it didn't git stable
>> kernels yet, but I can backport it on my own for now.
>
> I tried backporting it to 4.4, but it appears it won't be that
> trivial. Your patch ("ovl: proper cleanup of workdir") uses e.g.
> inode_lock_nested which is available in 4.5+. Commit that added this
> function: 5955102c9984f ("wrappers for ->i_mutex access") wasn't
> marked for stable, so I guess your patch won't go into 4.4 at all.
>
> I don't expect any magic solution for this, just saying, leaving a
> note for reference.

Conversion is trivial, in fact:

#define inode_lock(inode) mutex_lock(&(inode)->i_mutex)
#define inode_unlock(inode) mutex_unlock(&(inode)->i_mutex)
#define inode_trylock(inode) mutex_trylock(&(inode)->i_mutex)
#define inode_lock_nested(inode, subclass)
mutex_lock_nested(&(inode)->i_mutex, subclass)

And Greg promised to put these defines into -stable for easier
backport experience.

Thanks,
Miklos
