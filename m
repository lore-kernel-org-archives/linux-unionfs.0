Return-Path: <SRS0=xnyB=A6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ACAC433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Jul 2020 18:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52B9820684
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Jul 2020 18:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgGSSLU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Jul 2020 14:11:20 -0400
Received: from out20-1.mail.aliyun.com ([115.124.20.1]:54970 "EHLO
        out20-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGSSLT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Jul 2020 14:11:19 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436287|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.227693-0.00116489-0.771142;FP=0|0|0|0|0|-1|-1|-1;HT=e01l07447;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.I4NwKUa_1595182276;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.I4NwKUa_1595182276)
          by smtp.aliyun-inc.com(10.147.42.197);
          Mon, 20 Jul 2020 02:11:17 +0800
Date:   Mon, 20 Jul 2020 02:11:16 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 0/3] Running unionmount testsuite from xfstests
Message-ID: <20200719181116.GG2557159@desktop>
References: <20200531110156.6613-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200531110156.6613-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

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
> 
> What does it take to install unionmount testsuite?
> As README.overlay says:
> 
>   git clone https://github.com/amir73il/unionmount-testsuite.git
>   ln -s $PWD/unionmount-testsuite <path-to-xfstests>/src/

I'm really sorry for the long-long delay..

The test itself looks really good to me, my only concern is that
the updates in unionmount repo are not visible to fstests, and may cause
new failures, which are out of fstests' control. But I'm not sure if
this really is a problem for people.

I came up with two options anyway
- add unionmount tests as a submodule of fstests
- put unionmount tests in fstests

I'd like to hear what people think about this patchset, any other
comments & suggestions are welcomed!

Thanks,
Eryu

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
