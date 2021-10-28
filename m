Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7669CC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 20:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA9C60EFF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 20:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhJ1UoP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:44:15 -0400
Received: from mout.gmx.net ([212.227.15.15]:43707 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231201AbhJ1UoO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Oct 2021 16:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635453705;
        bh=t0fVzrS7v1XAqQqZAOUGB/pBCZCTikQZ5YQcSsLsccA=;
        h=X-UI-Sender-Class:Date:To:From:Subject;
        b=khS1zXu/k1t8bT0C+WTthsYk+eOZIelbJ4GJoGagwPvsNSHtKM7wtLrqTIOQBQ19b
         DhE0hZpuGGm5FrlQKHXQNqlFnJTrzkVyiET5Dr3NMugIv9R9b3CMN8G+Ofu4oQ8TVf
         aE5AcjEGVNy1z+lMhI8d+VzIjVEvqn1k7v0RGxnI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.15.55] ([109.104.55.23]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M4JqV-1mfv6O2Lqb-000P7q; Thu, 28
 Oct 2021 22:41:45 +0200
Message-ID: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
Date:   Thu, 28 Oct 2021 22:41:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
From:   =?UTF-8?Q?Georg_M=c3=bcller?= <georgmueller@gmx.net>
Subject: overlayfs: supporting O_TMPFILE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KGoDTfywZBi2H9+PUsos7H3Rj71XPbT9wVGMwmv0+kZ31sdCDRh
 3FXH3Jbxn0nHM1vZLG2fK77KS2wPoxjVEtX2riCGzx9SK+ZJbQZ77nbFA6Im6otrTc+A1OK
 GfzX/Ozn+oialMqzQB9hRRnYP84ThSayEljD993MWcOYH524m4HeEYScCrCEh/669OweH8b
 qK9Cj+KCxe0ei0kAV0Xdg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DaTpy1zxj+g=:krrIEzTBvEqyF8hY/yJlkF
 HpflnMR4MU97RzjDwXwQrK0gX0fJTcbKyYfeuRuUVNKRuHYJUErcag/Rx9bxM+z31zajIK7pK
 hX5bGORLdpL/m0cXrlNrpqknLAJjVurDb8gZoNZ3JPXjNwx4gzH7UWG/7/2b+lN2lCnjH67QA
 ldlmjThzYdGhNeWyoKr9hD3zNNIkImSbkgqkCTp7xLsbsGwIwFhnnvFSC4QBV5wYAFXC4+vN4
 fsS0jVGtm/iVOARVnPr9S4qygr1FBl5m5qp/hkKGaYjWD255OUbQULCvnmy/TVctPb/dUFLbM
 tThk4S3INR7QH8J9cr4yvVBZ8tctYHEqnnWG+aVSTX4Q3oGytQB0W+WTcv1AMu9kUEDkT7nHN
 cQTvJgi2M/+BSW+C7X8Zp636wpXJyyKDqurKUKVZluJ+3T46OS8Vc4ToC5DoDuGHqfsMuvBuJ
 ZYr8XWbjEVUpsYfLkEJe2QXbKnLHYJ0YpB6WkjrsvSYVbkUu8VBhqOk9hAsGd/UrJpKRY9px4
 uaNmumYw4eqLW4rg/K6iOPnFuxe9C6q+ArUJwyP94rW+xkujSRh7EO6kk67pe1vpJ/J6dlIFZ
 QM0NynN5k1e5SUWoqY1R1OVpNeh82EEkC2XIKjinVBGkVwuPsbMJc5ROA2ZVsE1urYHsuIAh0
 OpPSzu9CJEg+xWst2vo7PLNPcCLGW/NdcI6AVOf/TKGs9HVjSuL1yiiovWU9pLfx1m/Rc9cvn
 +rCz7nPhfYL5sEigW6BIRWCdDfv3BfknssjPFwOm3qAZYthXRRx3c6CKK62qYl4VCU1NsiT+z
 0o/hMPPJS1OY6B91hsFSgzu5I3Y5gaCj97aGWOgfrjBYrRRIESoetslUomNbkV4goC0L/yekL
 +AV32yRXQ69yDTV/XUnFCBocBFvMwZk8+Pj8Uhk2yntlJ5tS/6mcXcC3s3OqL08u1nEIIL3wg
 J+LS76BR2pRpGFY+XhSKjzMnZaXUpVaypo7K0XTNDIeVYe1JN12ecIFBZq5L/bwHLEbHBdBYF
 VaijlN4YJODzcB4ULpe1DQvbSoXxKlQLrr59RGQ9RUEk+9ao8RLA5bulKtivdbhMLBsCgtnhI
 Swj7YuyHawl0J8=
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

I was trying to implement .tmpfile for overlayfs inode_operations to suppo=
rt O_TMPFILE.

Docker with aufs supports it, but this is deprecated and removed from curr=
ent docker. I now have a work-around in my code (create tmpfile+unlink), b=
ut
I thought it might be a good idea to have tmpfile support in overlayfs.

I was trying to do it on my own, but I have some headaches to what is nece=
ssary to achieve the goal.

 From my understanding, I have to find the dentry for the upper dir (or wo=
rkdir) and call vfs_tmpdir() for this, but I am running from oops to oops.

Is there some hint what I have to do to achieve the goal?

Best regards,
Georg
