From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Mon, 24 Jul 2017 10:48:02 +0200
Message-ID: <CAJfpeguaYyBhaz3GG27i4-gP-CQ+RoqYttYCzP9HkykxdE_W7w@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com>
 <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com> <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:32889 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdGXIsE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jul 2017 04:48:04 -0400
Received: by mail-oi0-f51.google.com with SMTP id a9so18583415oih.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2017 01:48:04 -0700 (PDT)
In-Reply-To: <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jul 14, 2017 at 12:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> If you don't want to bundle index=on with NFS export, then no rush to merge
> these patches now. The added benefit on patch 9 (retroactive marking merge
> dir with origin for not exposing whiteouts) is relevant to a patch that is not
> going to land in v4.13 anyway. right?

Right.

Can we maybe postpone the verification until fh decode time?  That
would spare us from creating a new config option.

Thanks,
Miklos
