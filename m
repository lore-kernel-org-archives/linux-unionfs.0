Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93AEC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 15:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBFD206A2
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 15:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgFEPTL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:19:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55667 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgFEPTL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 11:19:11 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jhE7d-0002Na-PX; Fri, 05 Jun 2020 15:19:05 +0000
Date:   Fri, 5 Jun 2020 17:19:05 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        StuartIanNaylor <rolyantrauts@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kmxz <kxzkxz7139@gmail.com>
Subject: Re: OverlaysFS offline tools
Message-ID: <20200605151905.mne6agoxdprahvcc@wittgenstein>
References: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
 <20200108140611.GA1995@redhat.com>
 <CAOQ4uxiUXk-=RV+cCXvE_0KMjW-3xqFFVkhNx7TmnbtMySh7Gw@mail.gmail.com>
 <20200605143217.GB123988@redhat.com>
 <CAOQ4uxhP0VPMUSrPReKVaWLzyGkr1CFqiWNtGWOA29uLb0NEhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhP0VPMUSrPReKVaWLzyGkr1CFqiWNtGWOA29uLb0NEhg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 05, 2020 at 05:38:40PM +0300, Amir Goldstein wrote:
> > Hi Amir,
> >
> > I can't seem to access this abstract proposal (Despite the fact I
> > created a new login id).
> >
> 
> Maybe it needs to be accepted to become public, anyway:

The talks handed in via the plumber's website are not visible until
accepted. I think you can add Vivek as a co-author by editing your
submission if I'm not mistaken.

Christian
