Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBCDC433F5
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Feb 2022 14:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiBMO4X (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 13 Feb 2022 09:56:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiBMO4X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Feb 2022 09:56:23 -0500
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Feb 2022 06:56:16 PST
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F196F5AEE1
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Feb 2022 06:56:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644763267; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=mStRsKQUxbseTKTQHidYog6G4CVjHzbvwlM8VgUGXBPhmLcXFMsmRyo5M6M940xkP/gNO2gPEx37R1k1ElgrnA+7XxOU7Otj+HaY/qJ2pcx2KuGybT+AkHYLrN1OntGuQ4wC1fcIGPFR7Cqbu16/F9Hr6Q910Q4gO9QhXefbwIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1644763267; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=GJUQTCs9EfpBPf8oyu6GLucJslGQm6xkBxU4if1Typ0=; 
        b=rACH3NHgdoUqFGTEPxso/qFQKPErj8tFb/Xs27fZdqEgnY4SjC1XRFsXWsAlK1tIlDCCsjPE6/c+kO4kjV5MrwsQzChXTu6ANfYXpJWKhP7tbjSteFpGlpKtVZw9jyvwOWm0yOhJa/p7wT1l5o3tceQqEFSGypceav3123f5o38=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644763267;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:Content-Transfer-Encoding;
        bh=GJUQTCs9EfpBPf8oyu6GLucJslGQm6xkBxU4if1Typ0=;
        b=HVrkSfZx7fYxY0lohxacyYEeupbK5VDkPi50ukGhUtkPjnNcOsBSDnwIy4W2pmJZ
        sX8DJMyHAHigixZbDLFmF4Yxm3etq6En19WHaFP7EbEV2G+8MJvu8YIwGaxNCeOsyzf
        NjDlphi5YUuPpRwI+8LiuKkwdG+oDxmwU6z9+i3g=
Received: from [192.168.255.10] (113.116.159.36 [113.116.159.36]) by mx.zoho.com.cn
        with SMTPS id 1644763265128197.25608189103343; Sun, 13 Feb 2022 22:41:05 +0800 (CST)
Message-ID: <8d81eae9-1fb9-6c66-2c31-b02540db6af7@mykernel.net>
Date:   Sun, 13 Feb 2022 22:41:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
To:     overlayfs <linux-unionfs@vger.kernel.org>
From:   Chengguang Xu <cgxu519@mykernel.net>
Subject: Question about fsync in copy-up operaton
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoCNMailClient: External
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Folks,

During copy-up when parent dir does not exist then will create parent 
dir first.
However, I noticed only regular file calls fsync in the end of copy-up 
operation,
so how newly created parent dir get synced in this case?


Thanks,
Chengguang
