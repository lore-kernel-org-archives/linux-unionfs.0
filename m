From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Wed, 16 Aug 2017 13:16:06 +0200
Message-ID: <CAOQ4uxij6+0Fde2gDCXaQ8ZhwuFXYjKGgjucQzpugkqiMON5Jg@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-6-git-send-email-amir73il@gmail.com> <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
 <CAOQ4uxiYVuhqbzmM0yx+3cUKhhzfrjBubHwKo6ro1FXedJ-Tqg@mail.gmail.com>
 <CAJfpegumm16iy4v7vVkOOM0upvc=_jmuMxTiXn+cgEfi5c8FFw@mail.gmail.com>
 <CAJfpeguKQbG-EZTziROiKy+2t6iQU3FEwfZmc9ezPX_voEyTmA@mail.gmail.com>
 <CAJfpeguVYLdh5sc7-TCKVrdPdVGhxh3oSeP=EfN=nArh6wi_fA@mail.gmail.com>
 <CAOQ4uxhXQi-7sNTYxpMnDJGHC95r2QFAaoeeY5GQYWCe30EZOA@mail.gmail.com>
 <CAJfpegsCF8ZssutAe0yKEL4Bn1LZrMvqK5MXk8oQ7jj5fm0RtQ@mail.gmail.com>
 <CAOQ4uxg+ZRwa4_SERh6a_yU=RHFBEAGwumSJTBhrXr+rETnWAQ@mail.gmail.com>
 <CAJfpegtuepxej_o9Svb=4RoyLDryoKSXWts6_0PE79-ZjiRy0g@mail.gmail.com>
 <CAOQ4uxgtBzq8_HtSfKxGNT3mx_erg3MHw09z-ZQ25GK3RJFk6w@mail.gmail.com>
 <CAJfpeguKE2o=6bQm6q99oZXoP5w8Qt0qKZzbRDm7kGS0wYzvmA@mail.gmail.com>
 <CAJfpeguM5eS2caT_k6wE++sSrBi9kGE1aLys5h6a5S+tQGJg6A@mail.gmail.com>
 <CAOQ4uxif79cbhYJxgHzkG0jpNgginMimvfgm-iSXAnuRkmWUqw@mail.gmail.com>
 <CAOQ4uxgcUGi7UdJZ5=d2dvUW1H902UEFYTGhqJ7njGmACzegZw@mail.gmail.com> <CAJfpegs1X_Se_yn3yzQtSyHpdbY8bnR0Nofom5eOfxFYH4hydg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34414 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbdHPLQH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2017 07:16:07 -0400
Received: by mail-oi0-f54.google.com with SMTP id x3so32680043oia.1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2017 04:16:07 -0700 (PDT)
In-Reply-To: <CAJfpegs1X_Se_yn3yzQtSyHpdbY8bnR0Nofom5eOfxFYH4hydg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jul 31, 2017 at 12:58 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sat, Jul 29, 2017 at 12:33 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>
>> One thing that stands out in "my" patch ("ovl: constant d_ino across copy up")
>> The comments and commit message claim "When all layers are on the same fs",
>> but the patch doesn't actually checks that.
>
> I does in  ovl_cache_update_ino().   That check would be more logical
> in ovl_calc_d_ino(), though.   Fixed.
>

I see the patches in overlayfs-next still don't have the ovl_same_sb()
test in ovl_calc_d_ino(). I don't really mind.
BTW, do you intend to apply/rework Chandan's non-samefs patches for next?
if so, the current location of ovl_same_sb() really doesn't matter..

Amir.
