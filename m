Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C21CDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbjJLIdM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbjJLIdM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 04:33:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B7791
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 01:33:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFED7C433C8;
        Thu, 12 Oct 2023 08:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697099590;
        bh=7vzZqfd4Fyeefal/NcUn6HWbFID0WxdJt5ZqojxZgZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=geG3L9qegQZoJ8GNqPeCoMvtPp0hGf1rdMr7a2FRjvLjVLD34JMi/lQR0Z0wSLmQ7
         xv+ixSSPzWnirSPXeXys4WxE3Pffl6leCfhV3PeYB4b+W2jwQpY6ga5+QhDy4uUTK6
         f5YW+NyKSSclkQRLD5bGj70Yxw/HlRTZeXhwu8SRC2Bi8Hho5D7WFQCZDCQjEF2VqN
         Qu9tkzG1wjDOWA2E2tSrZNvLRIidwU+qx3D0qLhxc1sSF4z53w4LTAuV1pfV6j3VYR
         SMRZOm5eL3FtI0EgEbKkgTTOkEENcGtnVQcVCg17PKBcPIlu+DWSMIz26T/A9fM6KT
         DK3mzTKRzbhOA==
Date:   Thu, 12 Oct 2023 10:33:05 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
Message-ID: <20231012-insel-prospekt-463b9baad640@brauner>
References: <20231011164613.1766616-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231011164613.1766616-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 11, 2023 at 07:46:13PM +0300, Amir Goldstein wrote:
> Before commit b36a5780cb44 ("ovl: modify layer parameter parsing"),
> spaces and commas in lowerdir mount option value used to be escaped using
> seq_show_option().
> 
> In current upstream, when lowerdir value has a space, it is not escaped
> in /proc/mounts, e.g.:
> 
>   none /mnt overlay rw,relatime,lowerdir=l l,upperdir=u,workdir=w 0 0
> 
> which results in broken output of the mount utility:
> 
>   none on /mnt type overlay (rw,relatime,lowerdir=l)
> 
> Store the original lowerdir mount options before unescaping and show
> them using the same escaping used for seq_show_option() in addition to
> escaping the colon separator character.
> 
> Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Seems good to me.
