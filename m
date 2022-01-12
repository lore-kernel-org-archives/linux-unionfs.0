Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CAEC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Jan 2022 18:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344055AbiALSqw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 13:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356457AbiALSqq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jan 2022 13:46:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A318C06173F
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 10:46:46 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id k18so5868811wrg.11
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 10:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=K6PZgQeNdmtjC1DBYIH5rKBRwYO2/uG0NztxOCAFhzM=;
        b=o++RGEfbC4nN3SgP0uDyJNwGVMzWLLY1UpHfZRPTkvwGTLzu5BI95ob/oSPdNO85AE
         /20R4wfcj9iR0n295BJDjq8roe+XpV/OhhM358FUOtwMNIbre61Uy7TBz4nYi3miF1hX
         xPVhkcJb8h5pFoGo7lz/ZRaW4mtkuvz+56nCJpYmJLONdtfg5HPzGunzM9vZHhuNbeNm
         2Xr0EcpxE2nOt1sdf0g8hpPZVrhTwYAwDFWiBKAAMmGULu1HitH1Cj/AUUrvqzhnyRQS
         b+U5oiOzfBbGYTzks5jyBUZHw4VVqBLH3vz3q0V/hgXr2JmuXUPp9cnRTTy+OnkJJpc4
         OHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=K6PZgQeNdmtjC1DBYIH5rKBRwYO2/uG0NztxOCAFhzM=;
        b=08vtMlD9IzGvPCAEkFld6HI1MdDA30D1T7n6IkjtXD7kadzeg78eETa45nrfc8mWrE
         ZXfTkvMdLFco7/T/oIDXCiNXTNgbTvI8896k8iNr1ZLHPx7dA8QhMJVIosXbzWErIckl
         Jg6+kNmPr9kIT6j7if0CCF7tZAR6lvp2AcqEa++T/RDw5p+LtbMEiisBnzPhghM7P6Fi
         tf6s4nidGbN+nFjdDCcxnHXumOMikLqFtN4Zz1OjLW4yOX6Zdtppc2TmfHnKxOGRaS6+
         F4Uwk0yQ07p1YduvC+cysIsvgl6KdZoNucT/lfzckD7HlSEEhMt1sULidtdy2Yv0NdFw
         jujA==
X-Gm-Message-State: AOAM533OCbF4xlduVEKV3z0r8hlvfTIN+8qXuZOi7RDcRHX/INg2bJzL
        46vBdIGTa2I0bci/jnCYE5o=
X-Google-Smtp-Source: ABdhPJx7fdVQQJTPKB0iBqNibA00eL8yzu8FPesfEhpvI33Bn7wQ4X/O0msONHdnfpLvUV8oRccG6w==
X-Received: by 2002:a05:6000:382:: with SMTP id u2mr927122wrf.331.1642013204691;
        Wed, 12 Jan 2022 10:46:44 -0800 (PST)
Received: from mars.fritz.box ([2a02:8070:bb0:8700:3e7c:3fff:fe20:2cae])
        by smtp.gmail.com with ESMTPSA id r7sm7063678wmq.18.2022.01.12.10.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 10:46:44 -0800 (PST)
Message-ID: <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Kevin Locke <kevin@kevinlocke.name>, linux-unionfs@vger.kernel.org
Date:   Wed, 12 Jan 2022 19:46:43 +0100
In-Reply-To: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello Miklos

On Wed, 2022-01-12 at 19:33 +0100, Christoph Fritz wrote:
> This patch is fixing a NULL pointer dereference to get a recently
> introduced warning message working.

With that patch applied, a lot of these are popping up now:

[    7.132514] overlayfs: failed to retrieve upper fileattr (index/#26, err=-25)
[    7.141520] overlayfs: failed to retrieve upper fileattr (index/#27, err=-25)
[    8.699070] overlayfs: failed to retrieve upper fileattr (index/#7, err=-25)
[    8.715804] overlayfs: failed to retrieve upper fileattr (index/#8, err=-25)
[    8.723218] overlayfs: failed to retrieve upper fileattr (index/#9, err=-25)
[    8.829887] overlayfs: failed to retrieve upper fileattr (index/#43, err=-25)
[    9.387676] overlayfs: failed to retrieve upper fileattr (index/#a, err=-25)
[    9.667531] overlayfs: failed to retrieve upper fileattr (index/#b, err=-25)
[    9.874005] overlayfs: failed to retrieve upper fileattr (index/#c, err=-25)
[    9.934664] overlayfs: failed to retrieve upper fileattr (index/#58, err=-25)
[    9.942036] overlayfs: failed to retrieve upper fileattr (index/#59, err=-25)
[    9.949406] overlayfs: failed to retrieve upper fileattr (index/#60, err=-25)
[    9.956738] overlayfs: failed to retrieve upper fileattr (index/#61, err=-25)
[   10.311610] overlayfs: failed to retrieve upper fileattr (index/#d, err=-25)
[   10.712019] overlayfs: failed to retrieve upper fileattr (index/#e, err=-25)
[   31.901577] overlayfs: failed to retrieve upper fileattr (index/#64, err=-25)

These have been -ENOIOCTLCMD errors but got (falsely?) converted to
-ENOTTY by the recently introduced commit 5b0a414d06c3 ("ovl: fix filattr copy-up failure"):

+	if (err == -ENOIOCTLCMD)
+		err = -ENOTTY;

Any ideas?

Thanks
 -- Christoph

