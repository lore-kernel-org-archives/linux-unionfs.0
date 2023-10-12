Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBB4CDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 15:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbjJLPTi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbjJLPTh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 11:19:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F042C0
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 08:19:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF68C433C7;
        Thu, 12 Oct 2023 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697123974;
        bh=U4AKeNaF72XkPR09CAo/CmamDqWb5tGZteAAH165Ed4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pC6SWNXcIyGXxi6ZJ65IXuqq3wuDy1vJy4qGCh+U3SW7ug9rG4/uC/0AZP1Jrgu3B
         3cG5AzKKlsWK82pW2IbiD+iQ1CrbYXyX4MwYptTHrSoh31wjPWljy2AHCIpN9FA8f3
         8aOcNpku4J3h/WXwBMLXozQfoa7QIy37n5HM18X0mLO4xaryo4fXlE4+S3Jgb4az8X
         KMAnVlzX6Y3QUk/TD1ZX4e+iZncSHp/m/dGLg4hD1ZuvujM/OyrPW9WlmhctdjlARr
         T3stQwfCmANYAc9SPVQ02Hn6BpN09q9/wREdcmBoLRWM0NXcdZFRPpa+F/fOpqGX4L
         XCL+jMh1SXQ7A==
Date:   Thu, 12 Oct 2023 17:19:30 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: factor out vfs_parse_monolithic_sep() helper
Message-ID: <20231012-anweisen-aufpeppen-8f750ad5a4bd@brauner>
References: <20231012134428.1874373-1-amir73il@gmail.com>
 <20231012134428.1874373-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231012134428.1874373-2-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 12, 2023 at 04:44:27PM +0300, Amir Goldstein wrote:
> Factor out vfs_parse_monolithic_sep() from generic_parse_monolithic(),
> so filesystems could use it with a custom option separator callback.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Christian,
> 
> If you can ack this patch, I'd rather send it to Linus for 6.6-rc6,
> along with the two ovl option parsing fixes.

Sounds good to me.
Acked-by: Christian Brauner <brauner@kernel.org>
