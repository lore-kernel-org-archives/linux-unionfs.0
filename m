Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921B5C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 17:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4902073B
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 17:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kuugdz8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgFARw2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 13:52:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45221 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727808AbgFARw1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 13:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591033945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gdoio9t8baV+cygMe6YDVbPQvz9cJ3ClVCmXDB0Yzeg=;
        b=Kuugdz8+uUPImzQPFhvbd/jIOF3pBL7H2B+Y2YrAVw+bM1KFEkX6TMNdtAVh6zAlfQ/DLL
        bOfyhMJIyICNCEGTVZ0R+4QN1Sf2yFTi1t9CGgcmSxkeWN2MNKssTCbUAAgGQ9PMUTO5ep
        SOmNJdl+obYE//8ePjmFd6Pkn5lkIrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-9XF_UrHLPtumDaPXNTsf7A-1; Mon, 01 Jun 2020 13:52:21 -0400
X-MC-Unique: 9XF_UrHLPtumDaPXNTsf7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFEA0801504;
        Mon,  1 Jun 2020 17:52:19 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD24B1002390;
        Mon,  1 Jun 2020 17:52:19 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 3B186220244; Mon,  1 Jun 2020 13:52:19 -0400 (EDT)
Date:   Mon, 1 Jun 2020 13:52:19 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/3] Running unionmount testsuite from xfstests
Message-ID: <20200601175219.GE3219@redhat.com>
References: <20200531110156.6613-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200531110156.6613-1-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 31, 2020 at 02:01:53PM +0300, Amir Goldstein wrote:
> Eryu,
> 
> unionmount testsuite has a lot more test coverage than the overlay
> xfstests, but it has a lot less exposure to testers.
> 
> The various test setups that I have added to unionmount testsuite since
> I took over the maintanace of the testsuite have even smaller exposure
> to testers.
> 
> These patches add overlay tests that are used as a harness to run
> different setups of unionmount testsuite.  I have been using this method
> for over two year for testing my overlayfs branches.

Hi Amir,

Is there a git branch somewhere with these changes. Its easier to pull
that one in and test.

Vivek

> 
> What does it take to install unionmount testsuite?
> As README.overlay says:
> 
>   git clone https://github.com/amir73il/unionmount-testsuite.git
>   ln -s $PWD/unionmount-testsuite <path-to-xfstests>/src/
> 
> Thanks,
> Amir.
> 
> Amir Goldstein (3):
>   overlay: run unionmount testsuite test cases
>   overlay: add unionmount tests with multi lower layers
>   overlay: add unionmount tests with nested overlay
> 
>  README.overlay        | 15 ++++++++++++
>  common/config         |  2 ++
>  common/overlay        | 54 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/100     | 38 ++++++++++++++++++++++++++++++
>  tests/overlay/100.out |  2 ++
>  tests/overlay/101     | 39 +++++++++++++++++++++++++++++++
>  tests/overlay/101.out |  2 ++
>  tests/overlay/102     | 40 ++++++++++++++++++++++++++++++++
>  tests/overlay/102.out |  2 ++
>  tests/overlay/103     | 38 ++++++++++++++++++++++++++++++
>  tests/overlay/103.out |  2 ++
>  tests/overlay/104     | 39 +++++++++++++++++++++++++++++++
>  tests/overlay/104.out |  2 ++
>  tests/overlay/105     | 40 ++++++++++++++++++++++++++++++++
>  tests/overlay/105.out |  2 ++
>  tests/overlay/106     | 41 ++++++++++++++++++++++++++++++++
>  tests/overlay/106.out |  2 ++
>  tests/overlay/107     | 41 ++++++++++++++++++++++++++++++++
>  tests/overlay/107.out |  2 ++
>  tests/overlay/108     | 41 ++++++++++++++++++++++++++++++++
>  tests/overlay/108.out |  2 ++
>  tests/overlay/109     | 41 ++++++++++++++++++++++++++++++++
>  tests/overlay/109.out |  2 ++
>  tests/overlay/110     | 39 +++++++++++++++++++++++++++++++
>  tests/overlay/110.out |  2 ++
>  tests/overlay/111     | 40 ++++++++++++++++++++++++++++++++
>  tests/overlay/111.out |  2 ++
>  tests/overlay/112     | 40 ++++++++++++++++++++++++++++++++
>  tests/overlay/112.out |  2 ++
>  tests/overlay/113     | 41 ++++++++++++++++++++++++++++++++
>  tests/overlay/113.out |  2 ++
>  tests/overlay/114     | 39 +++++++++++++++++++++++++++++++
>  tests/overlay/114.out |  2 ++
>  tests/overlay/115     | 40 ++++++++++++++++++++++++++++++++
>  tests/overlay/115.out |  2 ++
>  tests/overlay/116     | 40 ++++++++++++++++++++++++++++++++
>  tests/overlay/116.out |  2 ++
>  tests/overlay/117     | 41 ++++++++++++++++++++++++++++++++
>  tests/overlay/117.out |  2 ++
>  tests/overlay/group   | 18 +++++++++++++++
>  40 files changed, 843 insertions(+)
>  create mode 100755 tests/overlay/100
>  create mode 100644 tests/overlay/100.out
>  create mode 100755 tests/overlay/101
>  create mode 100644 tests/overlay/101.out
>  create mode 100755 tests/overlay/102
>  create mode 100644 tests/overlay/102.out
>  create mode 100755 tests/overlay/103
>  create mode 100644 tests/overlay/103.out
>  create mode 100755 tests/overlay/104
>  create mode 100644 tests/overlay/104.out
>  create mode 100755 tests/overlay/105
>  create mode 100644 tests/overlay/105.out
>  create mode 100755 tests/overlay/106
>  create mode 100644 tests/overlay/106.out
>  create mode 100755 tests/overlay/107
>  create mode 100644 tests/overlay/107.out
>  create mode 100755 tests/overlay/108
>  create mode 100644 tests/overlay/108.out
>  create mode 100755 tests/overlay/109
>  create mode 100644 tests/overlay/109.out
>  create mode 100755 tests/overlay/110
>  create mode 100644 tests/overlay/110.out
>  create mode 100755 tests/overlay/111
>  create mode 100644 tests/overlay/111.out
>  create mode 100755 tests/overlay/112
>  create mode 100644 tests/overlay/112.out
>  create mode 100755 tests/overlay/113
>  create mode 100644 tests/overlay/113.out
>  create mode 100755 tests/overlay/114
>  create mode 100644 tests/overlay/114.out
>  create mode 100755 tests/overlay/115
>  create mode 100644 tests/overlay/115.out
>  create mode 100755 tests/overlay/116
>  create mode 100644 tests/overlay/116.out
>  create mode 100755 tests/overlay/117
>  create mode 100644 tests/overlay/117.out
> 
> -- 
> 2.17.1
> 

