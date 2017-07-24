From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Mon, 24 Jul 2017 15:14:35 +0300
Message-ID: <CAOQ4uxhuGZjepSaAkaJQ1BjL-ePVtfBrwio=5E5WFAaM+fpOgA@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
 <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com> <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33952 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753334AbdGXMOg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jul 2017 08:14:36 -0400
Received: by mail-yw0-f195.google.com with SMTP id a12so4831377ywh.1
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2017 05:14:36 -0700 (PDT)
In-Reply-To: <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jul 24, 2017 at 11:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jul 14, 2017 at 12:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> If you don't want to bundle index=on with NFS export, then no rush to merge
>> these patches now. The added benefit on patch 9 (retroactive marking merge
>> dir with origin for not exposing whiteouts) is relevant to a patch that is not
>> going to land in v4.13 anyway. right?
>
> Right.
>
> Can we maybe postpone the verification until fh decode time?

Not sure I follow.
Failure to verify lower dir can result in merge dir not being merged or being
merged with a different lower dir (followed by fh).

The question is which inode we choose to encode in case lower dir cannot be
verified: the unverified lower inode, the stored origin inode or the
upper inode.

Are you suggesting that "normal" lookup will merge the unverified lower dir
and then a pair of encode/decode will result in another dentry?
or are you suggesting to return ESTALE in that case?
If latter, then that error we be permanent? encode/decode will alway end up
with ESTALE??

Please explain.

Amir.
