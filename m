Return-Path: <SRS0=SPNM=33=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4200C352A2
	for <linux-unionfs@archiver.kernel.org>; Fri,  7 Feb 2020 10:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA4CB214AF
	for <linux-unionfs@archiver.kernel.org>; Fri,  7 Feb 2020 10:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581070396;
	bh=aymen6h+oW13mB51w2muor2ByjcdV9gYJhBBx+DOBsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2TOaPSV3maKj22VG01Nz/HYLLv7B7+El4vFQpGaPYu8mO0ih6MHDEMIARyJ7GU8LR
	 qmdQPtKoEsT+PnmazqGc8NF82jLX2es2qpwvgk0SETx0tZO4RmHapnW6HMPvhmcV1G
	 HNnoFFzQUDc5sVGdN2EX97CYLzSi76XcFhjR3PX8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgBGKNM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 05:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbgBGKNM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Feb 2020 05:13:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BA820838;
        Fri,  7 Feb 2020 10:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581070391;
        bh=aymen6h+oW13mB51w2muor2ByjcdV9gYJhBBx+DOBsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOwkWt+YrSgBCQyFZwlGofhya/RiacLWlKRO2/7tFAP3I+8pCiedF53Sx3ma8hTVa
         oDYMWDzgRjD5aH9mll6LLHHhGvH8T7oH7CkTEpbEXKHB8BKz6xlvnZwnUm8Dt4dGB5
         71eSi7mUAgsMezpCwGqVZc3b2JWpRhc/J1D4/PUY=
Date:   Fri, 7 Feb 2020 11:13:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Cc:     ioanna.alifieraki@gmail.com, jay.vosburgh@canonical.com,
        miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsa@csail.mit.edu
Subject: Re: [4.4.y PATCH] Revert "ovl: modify ovl_permission() to do checks
 on two inodes"
Message-ID: <20200207101308.GA629374@kroah.com>
References: <20200204184958.6586-1-ioanna-maria.alifieraki@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204184958.6586-1-ioanna-maria.alifieraki@canonical.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Feb 04, 2020 at 06:49:58PM +0000, Ioanna Alifieraki wrote:
> This reverts commit b24be4acd17a8963a29b2a92e1d80b9ddf759c95.
> 
> Commit b24be4acd17a ("ovl: modify ovl_permission() to do checks on two
> inodes") (stable kernel  id) breaks r/w access in overlayfs when setting
> ACL to files, in 4.4 stable kernel. There is an available reproducer in
> [1].

Thanks, now reverted.

greg k-h
