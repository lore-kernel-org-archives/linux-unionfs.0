Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B200EB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 09:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjFTJUR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjFTJT4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 05:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394C91703
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 02:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0C7F60F8F
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 09:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A078C433C0;
        Tue, 20 Jun 2023 09:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687252794;
        bh=CoRQYnDbvK0zu3jljS0VcgCLdzLsXCXKilNsKoIPSM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XrRBdGjo5nc6/ZOxZdufoUMoh8kXuqt+O4OXjrg83KOqUmSfoRyfal3Yfs3/r+o/L
         6lVrb+n1XrvR781h//HzUHpd9AZF307b1NZkNR4vpPrAusuc8XDlAgOxeVjKd6EoZa
         i25flxQfwFrqBuuRPrcIn+Hqq3q9zzeQKecxc2yj9GI1O/g0Cpj2V4C5IqW6Di4fP3
         h5urnsnlxapdwf3s0sqA9ChLCVjeQJVIuAz9KO7HgTsX2gBcKHgOLCHTnSAn99PMLa
         WCx9Y6cnimQ4ovvZltS+Cq1HhK9STNV7ya4Taox5YoFXQ0cQjogSzULvx7UsB6GXwy
         ZicDdx7amOTzg==
Date:   Tue, 20 Jun 2023 11:19:50 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] ovl: factor out ovl_parse_options() helper
Message-ID: <20230620-dossier-irreversibel-75d850ce975b@brauner>
References: <20230617084702.2468470-1-amir73il@gmail.com>
 <20230617084702.2468470-6-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230617084702.2468470-6-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jun 17, 2023 at 11:47:02AM +0300, Amir Goldstein wrote:
> For parsing a single mount option.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Fine by me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
