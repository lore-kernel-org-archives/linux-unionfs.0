Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA91CC001B0
	for <linux-unionfs@archiver.kernel.org>; Mon,  3 Jul 2023 19:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjGCTJD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 15:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGCTJD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2023 15:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360CDAF
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 12:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7085D60F24
        for <linux-unionfs@vger.kernel.org>; Mon,  3 Jul 2023 19:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C6C433C8;
        Mon,  3 Jul 2023 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688411340;
        bh=WjILfPLuDalAzQP1xRPS3ChkeLQUCRh1hiQ9Xuf8lL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qx2Nt4dIvBem2MGCxSDWvqkxolCtdbCyq8+lKDMJ2UPaUxytQORrfdPL/iU4q3n97
         l1Vl+jbzTljrHHtXDMUM38Z3lMuTMOUUUJZmp1dFIpKthwiwX8MnmWL1FtD5JwRSaI
         o0XPFLKwK7IUi/ecXpVYycv6eW/qFogznUwU+LDi4+nBUD4SYCabO6IxdBojw/wqMV
         uHQE0zMxUoKBOCrBsMgzZGyZK5vmtuMiro5ESOxBtRK9ZRKIXJYG5+jISchpxouMK2
         25IzRIYExZAx/m90g6+5NSfJHs8WUM4cGggoCaf37hYy5MbvA8RPD7J6rDZmSQ2SNV
         queb89SpsAaCA==
Date:   Mon, 3 Jul 2023 12:08:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Subject: Re: [PATCH v4 1/4] ovl: Add framework for verity support
Message-ID: <20230703190859.GB1194@sol.localdomain>
References: <cover.1687345663.git.alexl@redhat.com>
 <8bbfe13980cc9aa70e347811280b62eba930ffd2.1687345663.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bbfe13980cc9aa70e347811280b62eba930ffd2.1687345663.git.alexl@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 21, 2023 at 01:18:25PM +0200, Alexander Larsson wrote:
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index eb7d2c88ddec..b63e0db03631 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -405,6 +405,53 @@ when a "metacopy" file in one of the lower layers above it, has a "redirect"
>  to the absolute path of the "lower data" file in the "data-only" lower layer.
>  
>  
> +fs-verity support
> +----------------------
> +
> +During metadata copy up of a lower file, if the source file has
> +fs-verity enabled and overlay verity support is enabled, then the
> +digest of the lower file is added to the "trusted.overlay.metacopy"
> +xattr. This is then used to verify the content of the lower file
> +each the time the metacopy file is opened.
> +
> +When a layer containing verity xattrs is used, it means that any such
> +metacopy file in the upper layer is guaranteed to match the content
> +that was in the lower at the time of the copy-up. If at any time
> +(during a mount, after a remount, etc) such a file in the lower is
> +replaced or modified in any way, access to the corresponding file in
> +overlayfs will result in EIO errors (either on open, due to overlayfs
> +digest check, or from a later read due to fs-verity) and a detailed
> +error is printed to the kernel logs. For more details of how fs-verity
> +file access works, see :ref:`Documentation/filesystems/fsverity.rst
> +<accessing_verity_files>`.
> +
> +Verity can be used as a general robustness check to detect accidental
> +changes in the overlayfs directories in use. But, with additional care
> +it can also give more powerful guarantees. For example, if the upper
> +layer is fully trusted (by using dm-verity or something similar), then
> +an untrusted lower layer can be used to supply validated file content
> +for all metacopy files.  If additionally the untrusted lower
> +directories are specified as "Data-only", then they can only supply
> +such file content, and the entire mount can be trusted to match the
> +upper layer.
> +
> +This feature is controlled by the "verity" mount option, which
> +supports these values:
> +
> +- "off":
> +    The metacopy digest is never generated or used. This is the
> +    default if verity option is not specified.
> +- "on":
> +    Whenever a metacopy files specifies an expected digest, the
> +    corresponding data file must match the specified digest. When
> +    generating a metacopy file the verity digest will be set in it
> +    based on the source file (if it has one).
> +- "require":
> +    Same as "on", but additionally all metacopy files must specify a
> +    digest (or EIO is returned on open). This means metadata copy up
> +    will only be used if the data file has fs-verity enabled,
> +    otherwise a full copy-up is used.
> +

Thanks, it's not perfect but it's much improved.

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric
