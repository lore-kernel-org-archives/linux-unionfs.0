Return-Path: <SRS0=W3VS=6O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C00C8300A
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Apr 2020 09:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C38F2137B
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Apr 2020 09:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="d+dx+CYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgD3JPe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 05:15:34 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21168 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgD3JPe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Apr 2020 05:15:34 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1588238123; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=bARx/9P+iiKzHEgBk8hkFxEt2MX24QqxWYK1y587i+GSaQOGkB0KRqVmizLgYE1YMAsbPtbI35fUsR7KV/hXmY4yVXS9/ygPTahrDY2B0lzmVN84EPY2UHmD+Ca8TaAUbyRvfkXMk8lxCdbFXvhkvHDlhkrS/syBkrZxI+I+ChY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1588238123; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=/v82gsySA+bzu/I8RSGIIe2a0Mwk7H8zwCOc3SAXoYY=; 
        b=TtTcSBwu0Qzzu/AQW3VX6kbDFyZ1N34DQwbRJhGH+j94HAag8oohcLH5FUsF/66ipXnHW8f/urBuc51Njgt3ms/CUgwRgQpUlc52PUuOdbtzyPbDiOThWqVOrBB9uDn9C5RsBDH9gWr44G8UCQ87FLwDIAnXxNUTW0Q7DKytrus=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1588238123;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=/v82gsySA+bzu/I8RSGIIe2a0Mwk7H8zwCOc3SAXoYY=;
        b=d+dx+CYY8Cwtqy+noGPyNV+iMDYAz/aIF05VUMKhikjuOHLoE3tpU+usA2YKLOdx
        nPEN54CfH3cl2WtNjp4UEZ38ffrG6IbsWcBbAbVr4x7U0J8IjJxiOfM4KUwU5WDeP9K
        xkjnKC+53oHEwvxa4G8Wmkl6grYJNOVTXBtzgaIc=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1588238120661805.1648912551867; Thu, 30 Apr 2020 17:15:20 +0800 (CST)
Date:   Thu, 30 Apr 2020 17:15:20 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Cc:     "fstests" <fstests@vger.kernel.org>,
        "amir73il" <amir73il@gmail.com>, "miklos" <miklos@szeredi.hu>,
        "guaneryu" <guaneryu@gmail.com>, "cgxu519" <cgxu519@mykernel.net>
Message-ID: <171ca5e76d2.11a198ab91526.7776557945472155733@mykernel.net>
In-Reply-To: 
Subject: system hang on a syncfs test with nfs_export enabled
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

Hi=20

I'm doing some tests for my new version of syncfs improvement patch and I f=
ound an=20
interesting problem=E2=80=8B when combining dirty data && godown && nfs_exp=
ort.

My expectation  is  Pass or Fail  all tests listed below, Test2 looks a bit=
 strange and in my
opinion there is no strong connection between nfs_export/index and dirty da=
ta.
Any idea?


Test env and step like below:

Test1:
Compile module with nfs_export enabled
Run xfstest generic/474   =3D=3D> PASS

Test2:
Compile module with nfs_export enabled
Comment syncfs step in the test
Run xfstest generic/474   =3D=3D> Hang

Test3:
Compile module with nfs_export disabled
Run xfstest generic/474   =3D=3D> PASS

Test4:
Compile module with nfs_export disabled
Comment syncfs step in the test
Run xfstest generic/474   =3D=3D> FAIL




