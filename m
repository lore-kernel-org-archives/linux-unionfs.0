From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Wed, 10 Jan 2018 17:03:07 +0100
Message-ID: <CAJfpegvG772bKuzg=AEv8oOByVuixLjjfuTPA0mCX+8OB4Wwcg@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
 <20180108141335.GB9910@redhat.com> <CAOQ4uxjM4fQstyWkZcCWA0BO40sxuTd5wNESeL_B21SNp4zdgg@mail.gmail.com>
 <20180110145647.GA8999@redhat.com> <CAOQ4uxjjr=FzHLvYpBQ4Uebp9-fT2Prnm-XUNkc=LRaT3QMFHQ@mail.gmail.com>
 <20180110152715.GC8999@redhat.com> <CAJfpegttqS4mWR3Pt4AK9Zp32LoqD7kx_wXqyVaZjJpHjx+ZVQ@mail.gmail.com>
 <20180110154736.GD8999@redhat.com> <CAOQ4uxionx8d3hHQo+6eQOc6EAjUxBDfUS2u++Z=V+R_5-U2DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:37491 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755597AbeAJQDI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:03:08 -0500
Received: by mail-qk0-f178.google.com with SMTP id p13so23478262qke.4
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jan 2018 08:03:08 -0800 (PST)
In-Reply-To: <CAOQ4uxionx8d3hHQo+6eQOc6EAjUxBDfUS2u++Z=V+R_5-U2DA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 4:54 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 10, 2018 at 5:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Jan 10, 2018 at 04:38:22PM +0100, Miklos Szeredi wrote:
>>> On Wed, Jan 10, 2018 at 4:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> > On Wed, Jan 10, 2018 at 05:10:22PM +0200, Amir Goldstein wrote:
>>> >
> [...]
>>> >>
>>> >> It is exactly as you wrote. Not any less or any more of a security concern
>>> >> than a hand crafted redirect_dir. The only difference is that without
>>> >> metacopy=on and without redirect_dir=origin, the only implication of
>>> >> following an hand crafted origin would be to get a different st_dev/st_ino
>>> >> and for example, to fake that 2 files/dirs are the same while one is actually
>>> >> a rootkit/malware. So not that easy to exploit in current upstream.
>>> >
>>> > Right. Currently we seem to be using origin only for st_dev/st_ino so
>>> > no big impact. "metadata only copyup" is first feature which will make
>>> > data of lower file available using ORIGIN. So anymore features we add
>>> > using ORIGIN, we will have to be extra careful. Atleast make it
>>> > conditional on a mount option and document that using this mount option
>>> > on untrusted layer source can lead to privilege escalation.
>>>
>>> One more reason to use redirect, rather than origin.   Redirect at
>>> least constrains things to inside the overlay, while following origin
>>> can lead to anywhere within the filesystem.
>>>
>>> The other reason is backup+restore not breaking.
>>
>> Agreed. Looks like using REDIRECT instead of ORIGIN is more appealing. I
>> will give it a try and see what issues do I run into.
>>
>
> As long as we are listing the pros and cons, REDIRECT is limited by path length
> and a non-secure decode of non-dir ORIGIN is much faster then following all
> potential parent redirects.

True.

So there may be use case for following ORIGIN, but it should be
optional and the security and other implications clearly spelled out
in the doc.

Thanks,
Miklos
