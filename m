From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: overlayfs + ubifs: power cut results in "failed to create
 directory /overlay/work/work (errno: 17); mounting read-only"
Date: Tue, 6 Sep 2016 17:53:08 +0200
Message-ID: <CACna6rwSGU6WLZwVnd+x1iOjHOoNmhrBOCcvS-b1KDXs9gVF0Q@mail.gmail.com>
References: <58c7c482-9a51-73d1-7694-e1928f3bedb0@gmail.com>
 <d56ee9a9-5246-a609-b8ca-1c8dee322f46@nod.at> <CAJfpegt_Rw0O7mmP4scNPObAokwiNGs7m9ez1-tmjndOZDMXBg@mail.gmail.com>
 <CACna6rzJi37CYg86YgT+age8ebWX6BtpoEbz7uM18-QiWFvDxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34602 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbcIFPxJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Sep 2016 11:53:09 -0400
Received: by mail-oi0-f51.google.com with SMTP id m11so170822572oif.1
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Sep 2016 08:53:09 -0700 (PDT)
In-Reply-To: <CACna6rzJi37CYg86YgT+age8ebWX6BtpoEbz7uM18-QiWFvDxQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Richard Weinberger <richard@nod.at>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, LEDE Development List <lede-dev@lists.infradead.org>

On 6 September 2016 at 14:56, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> On 6 September 2016 at 14:50, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Sep 6, 2016 at 1:59 PM, Richard Weinberger <richard@nod.at> wrot=
e:
>>> overlayfs does not issue a recursive rm on workdir, AFAICT you are supp=
osed to cleanup
>>> workdir yourself before mounting.
>>> Miklos?
>>
>> Fixed in 4.8-rc5 by
>>
>> eea2fb4851e9 ("ovl: proper cleanup of workdir")
>>
>> I think it's better if kernel does the cleanup, but if it's easier to
>> upgrade userspace, then that's a valid workaround.
>
> Oh, this should solve my problem! It seems it didn't git stable
> kernels yet, but I can backport it on my own for now.

I tried backporting it to 4.4, but it appears it won't be that
trivial. Your patch ("ovl: proper cleanup of workdir") uses e.g.
inode_lock_nested which is available in 4.5+. Commit that added this
function: 5955102c9984f ("wrappers for ->i_mutex access") wasn't
marked for stable, so I guess your patch won't go into 4.4 at all.

I don't expect any magic solution for this, just saying, leaving a
note for reference.

--=20
Rafa=C5=82
