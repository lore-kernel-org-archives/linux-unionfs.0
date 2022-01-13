Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E127C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jan 2022 23:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbiAMXVy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 18:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiAMXVx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jan 2022 18:21:53 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C66C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jan 2022 15:21:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id a5so12845242wrh.5
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jan 2022 15:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rdGE0Qp9U8FMEp0qnkdZ+u8bLELBoPeXiIqoLzn28TA=;
        b=QNuAf8V/AnXlycXhHIJVSInFK+5bAyuPRSbbt7eOwpWi268It2osxZHINFSJ+oMBq8
         eQDtbtWKjreQatHqtuCZvI+9fMQEa8NYRmGWBHCDuEmLnbG6bveGfE8h6fWXH1aulLJr
         iNiFFYOfhghmf91tiPtxoXRZmh2FbNMFgYtgDeQx3JozEtCJ2TeIcX+3y5XSF40ACTEW
         lJYI3ONzZREwBodsrtDlx9vwL7TAqivwnDQ80HVGmNjUigbt+yfrCD0PLaffaxSpFIYp
         VhJZFaUJ/0oO1zMbDlDDWm1cPWdn2aZwdp1Znd2L7WHNH/mfRh/1oQ+RP5QKtGbM3ev5
         2++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=rdGE0Qp9U8FMEp0qnkdZ+u8bLELBoPeXiIqoLzn28TA=;
        b=Qw/bhBBsdcTkOdoTO+maayG0tjsF3egrc/WfdD+J36tyKxIAy74QFmuzDddRIR6UMX
         ENNVMuQoG97An+acA2YQINAiBwftVfDVaEMqz7Ubamo17tQ/hu38BvWxzjvUqOBd2RRR
         EICahku8ZQXVCYkjB1iu+yU2cDppVHMN0M8A2aTl+TSRFrWnF3BVLYzxBJJ0Ai4ksUo+
         JSelPX4uTSYM35ofGJP2EVV929kaSCf7bd2dHSjlQvaxhy84A4qyAo0vbYSvtNZ7I1Lb
         zwFaiWWRPcyuRp5dR5tZlljCA/cGW+zh2UxMU40uL+cJbgsQk451jMFxU/hdD1XRjDEg
         3bQg==
X-Gm-Message-State: AOAM530Xd7YPNFBAck/2OF+adoHajdcsxC4JGev3fgW+ZYd9MQ+KJcVB
        N37oueyQu/MPVXC4Hz47+uaGRxGt9Qs=
X-Google-Smtp-Source: ABdhPJy1coueXz7+ojhWF3w1i3nL4gEkPIFL/TFsQ+qDZkHC/fuW9ktI/laOwAqz4AtbqoTKMg5Omg==
X-Received: by 2002:a5d:464e:: with SMTP id j14mr33253wrs.252.1642116112003;
        Thu, 13 Jan 2022 15:21:52 -0800 (PST)
Received: from ?IPv6:2a02:8070:bb0:8700:3e7c:3fff:fe20:2cae? ([2a02:8070:bb0:8700:3e7c:3fff:fe20:2cae])
        by smtp.gmail.com with ESMTPSA id r62sm3621543wmr.35.2022.01.13.15.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 15:21:51 -0800 (PST)
Message-ID: <b8db86d9ae1eb24c927d40a2611dfd915a2548c9.camel@googlemail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Date:   Fri, 14 Jan 2022 00:21:50 +0100
In-Reply-To: <Yd9VbP3ruJNQbJsA@kevinlocke.name>
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
         <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
         <Yd9A9g9nsjwmbZtm@kevinlocke.name>
         <61820434137bd1be48b58cb25fcd4366db26a794.camel@googlemail.com>
         <Yd9VbP3ruJNQbJsA@kevinlocke.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org


> Could you provide a minimal, reproducible example for the log messages
> you mentioned observing?

Overlay gets configured in an initramfs, after switching root and while
booting these new error messages happen.


