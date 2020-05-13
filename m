Return-Path: <SRS0=GnLN=63=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5B0C2D0F6
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 03:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3703420714
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 03:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Wmr5K17o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgEMDRe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 23:17:34 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21128 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgEMDRd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 23:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589339828; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=k1wghdgSGxbyjfz4SXNiUiufhEe0vA9Ni0GyV7sjzwPqIGS+60qQHbVVU8/q5kPwWiZAFB6UlF32RAXk4V66/Voae5P51JsBoBZ33g0ofX4UHvyX7Ue5Jw/kC+G2o1kHzdXvEeTqLkSzvhm67/l1SOyo8wthgOjOFqyfNLORJk4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589339828; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=6DtmyoYJjZ9+qKxcG9TnkHxraUd7m6D0CMEnsQlqx0M=; 
        b=epIiMktM/t2DAWBj5pedcBKVRiYJs+M0Nst303FlzRYYadfoqacu4Z6Xn94dbscsyBf4j35THWCQmnlwAkfV+cszJEWWhBtjj6OihpdJWFitowenVjA6LfQhhtF/hM1qkRp7+saD6h0Okpf1taya13tNVgW7jKatrSK6mhOceGE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589339828;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=6DtmyoYJjZ9+qKxcG9TnkHxraUd7m6D0CMEnsQlqx0M=;
        b=Wmr5K17odhrMRFLrT1FLQA+vqvjKc0N6W6xXM3igZl0GHhJGg+QCQuYRaUyv87CX
        p4y8HqWtQJW3ymXP085Kk4uibEOvGJWyc/+zF7q2GrrcezDq2Nh3esm+toE7WFUEJHQ
        ZyZH9AMGNjXiBU75reZRFQAJLzTN94RMj43Ualb4=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1589339826796781.4564529978903; Wed, 13 May 2020 11:17:06 +0800 (CST)
Date:   Wed, 13 May 2020 11:17:06 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Eryu Guan" <eguan@linux.alibaba.com>
Cc:     "Amir Goldstein" <amir73il@gmail.com>, "Eryu Guan" <guan@eryu.me>,
        "miklos" <miklos@szeredi.hu>, "fstests" <fstests@vger.kernel.org>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1720c092a68.c8052b8d3001.6829163626760635444@mykernel.net>
In-Reply-To: <20200513011019.GY47669@e18g06458.et15sqa>
References: <20200506101528.27359-1-cgxu519@mykernel.net>
 <20200510155037.GB9345@desktop>
 <172015c8691.108177c8110122.924760245390345571@mykernel.net>
 <20200512162532.GD9345@desktop>
 <CAOQ4uxiFPrMWrhqjPo3PcgKFiKwSKfh7p+f5hM5fZYKr51HEWA@mail.gmail.com> <20200513011019.GY47669@e18g06458.et15sqa>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-05-13 09:10:19 Eryu Guan =
<eguan@linux.alibaba.com> =E6=92=B0=E5=86=99 ----
 > On Tue, May 12, 2020 at 07:56:35PM +0300, Amir Goldstein wrote:
 > > > >  > I see no feature detection logic, so test just fails on old ker=
nels
 > > > >  > without this feature? I tried with v5.7-r4 kernel, test fails b=
ecause
 > > > >  > each whiteout file has only one hardlink.
 > > > >
 > > > > That's true.
 > > >
 > > > I'd like to see it _notrun on old kernels where the feature is not
 > > > available. But that seems hard to do.. Do you have any better ideas?
 > > >
 > >=20
 > > I've got a few.
 > > 1. LTP has the concept of require minimum kernel version.
 > >     This would mean that functionality will be not be tested if featur=
e
 > >     is backported to old kernels.
 > > 2. We could add to overlayfs advertising of supported features, like
 > >      /sys/fs/ext4/features/, but it already does "advertise" the confi=
gurable
 > >      features at  /sys/module/overlay/parameters/, and we were already
 > >      asking the question during patch review:
 > >         /* Is there a reason anyone would want not to share whiteouts?=
 */
 > >         ofs->share_whiteout =3D true;
 > >      and we left the answer to "later" time.
 > >=20
 > > So a simple solution would be to add the module parameter (without add=
ing
 > > a mount option), because:
 > > - It doesn't hurt (?)
 > > - Somebody may end up using it, for some reason we did not think of
 > > - We can use it in test to require the feature
 >=20
 > Yeah, I think that works. And I see that ext4 and btrfs both have a
 > /sys/fs/<fs>/features directory and list supported features there, is
 > this something overlay could do? Or is this basically the same thing as
 > what you proposed?
 >=20

IMO, for those features which don't need to change module param, maybe feat=
ure list=20
is more suitable.


Thanks,
cgxu
=20






