Return-Path: <SRS0=sf8C=55=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9317C2BB55
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:52:18 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 096C52064A
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:52:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="VgKEtzjc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 096C52064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mykernel.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-unionfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgDMBwR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 21:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgDMBwQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Apr 2020 21:52:16 -0400
Received: from sender2-pp-o92.zoho.com.cn (sender2-pp-o92.zoho.com.cn [163.53.93.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A55C0A3BE0;
        Sun, 12 Apr 2020 18:52:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1586742712; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=WzsZXY11RjrPgTVbLMvH1NQ+HGu0EZfRT1FjBrnZWaNOxi7vTTx3Isd3kCzIXV9i+nkHTYPYwVKbxRXOJV65GONWoUNankydu559OBmB6lUcGXxRttank5SgaWMdyPeJRDdCLy6VRnqBc+FgwK3bZniYbNKe7hUmJ0I/TeneAMs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586742712; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=/wA5Spn5Id2B1+lvV6ANe4za/RAtTZQWWXSmmtoGsYo=; 
        b=jZ1kHqbKqQWHi5wZB1x7s+ZwUjRqQxGp6o8+dYvZ5cluZ2/57IUZNHf6t2yQGsMLVeoIwElJ6Aobsa2P587PSAHu5BcfrT/7vcXFqVqdJUCWZau0xzbY7mhRG2/N8VhF9bJ5H9bzw6fJAPQSh4kOlAP7ylaMaXUAFqGWLQqiAtE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586742712;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=/wA5Spn5Id2B1+lvV6ANe4za/RAtTZQWWXSmmtoGsYo=;
        b=VgKEtzjc1bteZBU6A8TrsoFaGTi5aT+I1T2pU2L/O882VjbtfVlVGcPudqkS5fYG
        zn1eVI/hJW4xi6b5x09jOBpgCdftmQDn9qQTK2LTEqlPHqirIXEWL4TGvWqHCXGedFb
        giuUHnJpcGaiiYccYJp+exSXJz6Nv6tMLPnX+lPU=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1586742711527496.54214749612606; Mon, 13 Apr 2020 09:51:51 +0800 (CST)
Date:   Mon, 13 Apr 2020 09:51:51 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Eryu Guan" <guan@eryu.me>
Cc:     "guaneryu" <guaneryu@gmail.com>,
        "fstests" <fstests@vger.kernel.org>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "miklos" <miklos@szeredi.hu>, "amir73il" <amir73il@gmail.com>
Message-ID: <171713c54e3.12c6e9d8e4849.2466630459143840888@mykernel.net>
In-Reply-To: <20200412112121.GB3923113@desktop>
References: <20200410012059.27210-1-cgxu519@mykernel.net> <20200412112121.GB3923113@desktop>
Subject: Re: [PATCH 1/2] common: add a helper for setting module param
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2020-04-12 19:20:34 Eryu Guan =
<guan@eryu.me> =E6=92=B0=E5=86=99 ----
 > On Fri, Apr 10, 2020 at 09:20:58AM +0800, Chengguang Xu wrote:
 > > Add a new helper _set_fs_module_param for setting
 > > module param.
 > >=20
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 >=20
 > I think this could go with the test, so a single patch introduces both
 > test case and the needed helper functions, and usually that's easier to
 > review, as we could know how the helper be used from the context.
 >=20

Hi Eryu,

OK, I'll put it into test patch in V2.

Thanks,
cgxu
