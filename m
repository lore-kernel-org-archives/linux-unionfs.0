Return-Path: <SRS0=aVUC=BY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499A3C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Aug 2020 09:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E161E20781
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Aug 2020 09:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Fj2MEnTu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgHNJX7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:23:59 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17165 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgHNJX7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Aug 2020 05:23:59 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1597397020; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=eZcUHJUkriGZAGHLzB2v3HzpNV1EzPzYwiofLvlW3FCUFx7RZWGoWprUAFOEIQ2vz8IF2sZJGaVbmdVn7HnYjoySbQjOrsh33PLT5K258gX+JnGRJJdgS3W6ZN5uRx9CCVuslbVVSiJo+RatjnoK3LksJ/lFBXGlIm+TadTI6DE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1597397020; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=rIbBJDVli+lSzpsCfcVO4h4zX71fzh02Aedv10jLZYE=; 
        b=f91Zxr030KM1Lx0dsyOofC6rqPENgdrZikh7Ot/MyA/zVl/KITDkdxwqm7BoS1lEG4IRpqkw5EDwfU1g5PgHo59wSzJ5vE+bwUHBeagR85iWFiPJFIQLP4vWTen//3S13GHIsh/xLjgTduZ32zSRb/qIsIb45nJmu8oSVPCxD+I=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1597397020;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=rIbBJDVli+lSzpsCfcVO4h4zX71fzh02Aedv10jLZYE=;
        b=Fj2MEnTuu/2NlYJbT8BD99dofQGOG/7nO7WDgWkdC4wyO/AnPcXOxcpKZq37Hyjt
        cdZrfgQfDAqnGyhM/hc1Ful0gnZ8SWd+TicE3KtRlyq8uDTIP8sdu9zyxTmtlsxT/+V
        9vhcnpV/HSwbCVUU5CgoBFpD9Kviak7GDIAZnkiU=
Received: from [10.0.0.2] (116.30.195.169 [116.30.195.169]) by mx.zoho.com.cn
        with SMTPS id 1597397017749438.73368801375614; Fri, 14 Aug 2020 17:23:37 +0800 (CST)
Subject: Re: [PATCH] ovl: fix incorrect extent info in metacopy case
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org
References: <20200624102011.4861-1-cgxu519@mykernel.net>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <c9faf864-c515-2657-fa7c-6ba24a9ea89f@mykernel.net>
Date:   Fri, 14 Aug 2020 17:23:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200624102011.4861-1-cgxu519@mykernel.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoCNMailClient: External
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 6/24/20 6:20 PM, Chengguang Xu wrote:
> In metacopy case, we should use ovl_inode_realdata() instead of
> ovl_inode_real() to get real inode which has data, so that
> we can get correct information of extentes in ->fiemap operation.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

ping


> ---
>   fs/overlayfs/inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 981f11ec51bc..a524af04b71d 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -472,7 +472,7 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   		      u64 start, u64 len)
>   {
>   	int err;
> -	struct inode *realinode = ovl_inode_real(inode);
> +	struct inode *realinode = ovl_inode_realdata(inode);
>   	const struct cred *old_cred;
>   
>   	if (!realinode->i_op->fiemap)
> 
