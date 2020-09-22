Return-Path: <SRS0=2bMn=C7=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0860C2D0E2
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Sep 2020 12:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43F220756
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Sep 2020 12:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIVMSX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 08:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgIVMSX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Sep 2020 08:18:23 -0400
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFEFC061755
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2020 05:18:23 -0700 (PDT)
Received: from kevinlocke.name (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 772F81C6FF48;
        Tue, 22 Sep 2020 12:18:20 +0000 (UTC)
Received: by kevinlocke.name (Postfix, from userid 1000)
        id 749931303754; Tue, 22 Sep 2020 06:18:18 -0600 (MDT)
Date:   Tue, 22 Sep 2020 06:18:18 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: document lower modification caveats
Message-ID: <20200922121818.GA133833@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
References: <82b537e0ca5fa38b492413bd665c0198e6761015.1597944769.git.kevin@kevinlocke.name>
 <fe78446e6565cda29cc2c87f3e3c1b2a16f5d5cc.1598149357.git.kevin@kevinlocke.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe78446e6565cda29cc2c87f3e3c1b2a16f5d5cc.1598149357.git.kevin@kevinlocke.name>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 2020-08-22 at 20:22 -0600, Kevin Locke wrote:
> Some overlayfs optional features are incompatible with offline changes
> to the lower tree[1][2][3] and may result in -EXDEV[4], -EIO[5], or
> other errors.  Such modification is not supported and the error behavior
> is intentionally not specified.
> 
> Update the "Changes to underlying filesystems" section to note this
> restriction.  Move the paragraph describing the offline behavior below
> the online behavior so it is adjacent to the following 3 paragraphs
> describing the NFS export offline modification behavior.
> 
> [1]: https://lore.kernel.org/linux-unionfs/20200708142353.GA103536@redhat.com/
> [2]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/
> [3]: https://lore.kernel.org/linux-unionfs/20200817135651.GA637139@redhat.com/
> [4]: https://lore.kernel.org/linux-unionfs/20200709153616.GE150543@redhat.com/
> [5]: https://lore.kernel.org/linux-unionfs/20200812135529.GA122370@kevinolos/
> 
> Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
> ---
> 
> Changes since v1:
> - Actually send to the maintainer this time.
>   (Sorry Miklos Szeredi, not sure what I was thinking on v1!)
> - Rebase onto overlayfs-next of
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
> 
> As mentioned with v1, I'm still open to collaborating on a combined
> patch if there is still interest in including Vivek's changes to the
> "Sharing and copying layers" section.
> 
> This patch does not mention nfs_export being incompatible with offline
> changes to lower, since the following 3 paragraphs specify the behavior
> (IIUC).  If the behavior of offline modification with nfs_export is
> undefined, should these paragraphs be removed?
> 
> Thanks for considering (again),
> Kevin
> 
>  Documentation/filesystems/overlayfs.rst | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> index fcda5d6ba9ac..9b39374afdbd 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -467,14 +467,18 @@ summarized in the `Inode properties`_ table above.
>  Changes to underlying filesystems
>  ---------------------------------
>  
> -Offline changes, when the overlay is not mounted, are allowed to either
> -the upper or the lower trees.
> -
>  Changes to the underlying filesystems while part of a mounted overlay
>  filesystem are not allowed.  If the underlying filesystem is changed,
>  the behavior of the overlay is undefined, though it will not result in
>  a crash or deadlock.
>  
> +Offline changes, when the overlay is not mounted, are allowed to the
> +upper tree.  Offline changes to the lower tree are only allowed if the
> +"metadata only copy up", "inode index", and "redirect_dir" features
> +have not been used.  If the lower tree is modified and any of these
> +features has been used, the behavior of the overlay is undefined,
> +though it will not result in a crash or deadlock.
> +
>  When the overlay NFS export feature is enabled, overlay filesystems
>  behavior on offline changes of the underlying lower layer is different
>  than the behavior when NFS export is disabled.

Ping.

I think users would benefit from documenting these restrictions, using
the above patch Vivek's or another.  I'm still open to working out any
issues over how best to do that.

Thanks,
Kevin
