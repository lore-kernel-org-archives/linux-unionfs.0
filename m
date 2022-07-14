Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E9DC43334
	for <linux-unionfs@archiver.kernel.org>; Thu, 14 Jul 2022 21:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240624AbiGNVg6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 17:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbiGNVg6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Jul 2022 17:36:58 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A818066AD9
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2022 14:36:54 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-f2a4c51c45so4054780fac.9
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2022 14:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dMsmvbkREQ7KC9eGxfbeklXcQRZHnKDY78xwrC9tKMk=;
        b=ALZYzwPvLLgaaZuNAiyDE1NXdHZ1z84Gf5xF5jMSsgEHTyXsL6oFp+ZjipwHvVvFzm
         TrKV7+yCe7S62tBtYSry/HCkP+RI1oguAi+GWQpigF5i9yBQXxwn5mEiGc0k2WRCalue
         Va5CwZcDo5AszHEPTRe9XNFn3PS2HMwL0ilTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dMsmvbkREQ7KC9eGxfbeklXcQRZHnKDY78xwrC9tKMk=;
        b=rBJ3blidRSDdY6kc2isL9DCgVuAELq9yjJVYeFR9jPaX5HZNKMGtbE6Nd75tQNjTAi
         hfY9UO6bOOkEOvIFr9NoN1n2BGsF1H3FQJrpf44AxtOEL0pZHd9BQc3ThRAe/VLBX8DC
         mPkN/ukstqUK0ScEEwmzOAFWDzJome/hxO9MJY+mM9bijbZTlst2rwjO+eRB6dTN7yFE
         d+54ue3kr7F+LkupKHac8E4GHKx6MFctZTl5wuWF71GYvkohz0xHDyBoqe96EImY3HTr
         dv78NeWSETpvFmk2tWcxrQOAGbFI8AH4uUtmCZs5HSUUGDcf7J1zPt99aYyCaWuMvZmW
         nGCg==
X-Gm-Message-State: AJIora/t7Cn/znVuyfygM5MzwIHHv0qZMCixOeP5bkd7p1RFh/39Cgg8
        CSYRG5n0lLH8sauUpajijg/TXw==
X-Google-Smtp-Source: AGRyM1tlwLQnIbQ6UHKexG6NWKRkWlDRbT1I/TR2dwuHH3PhVJpDf9EtHgNBha7yVB4C1rqPax6Xkg==
X-Received: by 2002:a05:6870:4389:b0:10c:5293:76bf with SMTP id r9-20020a056870438900b0010c529376bfmr5817323oah.7.1657834614051;
        Thu, 14 Jul 2022 14:36:54 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:1f77:47fa:4ce9:ddce])
        by smtp.gmail.com with ESMTPSA id t4-20020a4a96c4000000b004356bc04240sm1109830ooi.5.2022.07.14.14.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:36:53 -0700 (PDT)
Date:   Thu, 14 Jul 2022 16:36:53 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] acl: make posix_acl_clone() available to overlayfs
Message-ID: <YtCMdTbZPB3po8D/@do-x1extreme>
References: <20220708090134.385160-1-brauner@kernel.org>
 <20220708090134.385160-3-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708090134.385160-3-brauner@kernel.org>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:01:33AM +0200, Christian Brauner wrote:
> The ovl_get_acl() function needs to alter the POSIX ACLs retrieved from the
> lower filesystem. Instead of hand-rolling a overlayfs specific
> posix_acl_clone() variant allow export it. It's not special and it's not deeply
> internal anyway.
> 
> Cc: Seth Forshee <sforshee@digitalocean.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
