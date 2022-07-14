Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BABC433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 14 Jul 2022 21:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbiGNVhm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 14 Jul 2022 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiGNVhm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Jul 2022 17:37:42 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB12691F4
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2022 14:37:41 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id y10-20020a9d634a000000b006167f7ce0c5so2211455otk.0
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2022 14:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D+FsdMnagtlQWg7EpOvVYO8VxY4wT4ViqnmkSOQSf1g=;
        b=BlISIE50EWuqGs2pSf6u+AecHUHJjs/XSRwfLYQoAt6HE1QmRYsOSndg507rUGo6Od
         UAfBM2u/GZPKU+uHT0kiytiQVYBwdWacdn6lY/O+MAKr5t6l8q7A1YXofEwCG76e+VKo
         nni5pVlxjdI+aWymczG8vF2y3YRD91Wp5qEUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D+FsdMnagtlQWg7EpOvVYO8VxY4wT4ViqnmkSOQSf1g=;
        b=omv0cZ0LKpQmwX6tpb+tOQXL3n6lJsKWpWuT4efXBwUDtTa62wBEoz5rpN0+jlLmGn
         3XB2vJwHWaq4yP4HkByC0qYVngbyqmqYlnJZtwRfmZ8h+ltPmcRw3/Cc5EN55WWB9gCK
         0PznMuzEQ6XuRJ0BX8I1VQ/42NQ8vVnU1dwUhKquim7PwP5RteI2lO0421y1FHj8nBYw
         ZMUR2vANNswP+IwhYAKf5d2UncTBjkBUHBu+ngU42kVw28uYUQrb4QEdxMrP/ryMl/5y
         tY/oI5Png2n00keqG6U7MHsHA2w4Q2KjNRGc5GJDT5jH2f0kq/0bZ4iA4c5Jfm7aqjF0
         irsQ==
X-Gm-Message-State: AJIora/37cRi/aLi5dB4EcfgwsXB/hCZyXGrmaJTphITgdzFa4Hci9Cg
        z8j+gPj6QnYTzxplRRWujyjmxLFojjl7SQ==
X-Google-Smtp-Source: AGRyM1uiiyOrgUjghYTupTJqnQ45lcSn63sCHzij9ttAIQLAqktOzzPSlDa6t1QDy+liE1w7bj/Mww==
X-Received: by 2002:a9d:19a5:0:b0:616:8c70:79cd with SMTP id k34-20020a9d19a5000000b006168c7079cdmr4236024otk.277.1657834660640;
        Thu, 14 Jul 2022 14:37:40 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:1f77:47fa:4ce9:ddce])
        by smtp.gmail.com with ESMTPSA id m17-20020a056808025100b0033a3e6e7ce9sm702286oie.10.2022.07.14.14.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:37:40 -0700 (PDT)
Date:   Thu, 14 Jul 2022 16:37:40 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ovl: handle idmappings in ovl_get_acl()
Message-ID: <YtCMpAM0OY78m5LK@do-x1extreme>
References: <20220708090134.385160-1-brauner@kernel.org>
 <20220708090134.385160-4-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708090134.385160-4-brauner@kernel.org>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jul 08, 2022 at 11:01:34AM +0200, Christian Brauner wrote:
> During permission checking overlayfs will call
> 
> ovl_permission()
> -> generic_permission()
>    -> acl_permission_check()
>       -> check_acl()
>          -> get_acl()
>             -> inode->i_op->get_acl() == ovl_get_acl()
>                -> get_acl() /* on the underlying filesystem */
>                   -> inode->i_op->get_acl() == /*lower filesystem callback */
>          -> posix_acl_permission()
> 
> passing through the get_acl() request to the underlying filesystem.
> 
> Before returning these values to the VFS we need to take the idmapping of the
> relevant layer into account and translate any ACL_{GROUP,USER} values according
> to the idmapped mount.
> 
> We cannot alter the ACLs returned from the relevant layer directly as that
> would alter the cached values filesystem wide for the lower filesystem. Instead
> we can clone the ACLs and then apply the relevant idmapping of the layer.
> 
> This is obviously only relevant when idmapped layers are used.
> 
> Cc: Seth Forshee <sforshee@digitalocean.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: linux-unionfs@vger.kernel.org
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
