Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFBAEB64DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjFTJXj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjFTJXi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:23:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CEAF1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E27C61084
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 09:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB30DC433C0;
        Tue, 20 Jun 2023 09:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687253016;
        bh=vZWHCuA+SlfbrLLMNyKL2PZS7R2wH+fdrlSdlQdrR3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4lD7GdE+xUr9n/7UZfFpQLTDFwGtib6RD6FfWVAexfproK9OslxElCX12Kcd38Py
         F5b6oABtpJUrGixE+4kBEV5XYJfu/qejXeq3OXoxx44kd84SGS0OZkAfANNnAyeCvY
         87iU2beoGIlTaDbMlEQ5idmIAT4yyJH6OQiBCc7v0Osgiv5Y9r+Idlf2z8vQgN+YN6
         D5mdgorS8x+O2mH+E1H8brfe4voRaH3MnKcjrmHTzKOWWDlju5WkKoomv0IL/CKsie
         sm2Jpyo9bMb/WGkAxwMkOYiPbGWgcmZKeSgQhQNhl4ActorqJuV/grwk4Z+rZt6d+I
         rO5OcXaA0GTNA==
Date:   Tue, 20 Jun 2023 11:23:33 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 4/5] ovl: store enum redirect_mode in config instead
 of a string
Message-ID: <20230620-bitten-bergwacht-2c51b4dd64da@brauner>
References: <20230617084702.2468470-1-amir73il@gmail.com>
 <20230617084702.2468470-5-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230617084702.2468470-5-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 17, 2023 at 11:47:01AM +0300, Amir Goldstein wrote:
> Do all the logic to set the mode during mount options parsing and
> do not keep the option string around.
> 
> Use a constant_table to translate from enum redirect mode to string
> in preperation for new mount api option parsing.
> 
> The mount option "off" is translated to either "follow" or "nofollow",
> depending on the "redirect_always_follow" build/module config, so
> in effect, there are only three possible redirect modes.
> 
> This results in a minor change to the string that is displayed
> in show_options() - when redirect_dir is enabled by default and the user
> mounts with the option "redirect_dir=off", instead of displaying the mode
> "redirect_dir=off" in show_options(), the displayed mode will be either
> "redirect_dir=follow" or "redirect_dir=nofollow", depending on the value
> of "redirect_always_follow" build/module config.
> 
> The displayed mode reflects the effective mode, so mounting overlayfs
> again with the dispalyed redirect_dir option will result with the same
> effective and displayed mode.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
