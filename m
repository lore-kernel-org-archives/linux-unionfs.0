Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36357 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbfA1WOM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Jan 2019 17:14:12 -0500
Received: by mail-yw1-f66.google.com with SMTP id i73so7412133ywg.3
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Jan 2019 14:14:12 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
 <CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
 <CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
 <CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
 <CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
 <CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
 <CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
 <CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
 <CAOQ4uxha2VNZ-Da-w6U5yxrqA3PkixXPevk9_5NvMzg4-KkWSg@mail.gmail.com>
 <CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com>
 <20190128192207.GA10240@redhat.com> <CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
 <CAJfpegth1vkgo67MbqfcmjXZLjxAW9mjoNaxLUW78iRtEqcaLQ@mail.gmail.com> <CAJfpegtay6O7S92eV0H=kV58E28z3Bmc4M0r6jYtoQkxSCjgUQ@mail.gmail.com>
In-Reply-To: <CAJfpegtay6O7S92eV0H=kV58E28z3Bmc4M0r6jYtoQkxSCjgUQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Jan 2019 00:14:00 +0200
Message-ID: <CAOQ4uxhFSa-DAs4_7YQ0DB6yjE7Qr76Dm9TNs17L1wKAnEMy+g@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jan 28, 2019 at 11:22 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Jan 28, 2019 at 10:17 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > Trying to put some code together...
>
> Very rudimentary patch attached.  It doens't do direct IO yet, but
> demonstrates what I meant about achoring the upper file in the inode.
>

Code looks good, but blows up on xfstests, so I'll wait for a baked patch
before testing.

> Also found the trick to actually make writeback work:
> super_setup_bdi() call in fill_super...
>

Cool, but when adding only setup_bdi() this to my code, I still don't see any
writeback. No writeback observed with your patch as well.

Speaking of which, did you read the warning sign above
simple_write_end()? Aren't you missing the mark_inode_dirty() call?

Thanks,
Amir.
