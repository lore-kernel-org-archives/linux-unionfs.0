Return-Path: <SRS0=WHUq=54=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA7EC2BA2B
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Apr 2020 11:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC87206E9
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Apr 2020 11:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgDLLU1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 07:20:27 -0400
Received: from out20-62.mail.aliyun.com ([115.124.20.62]:33617 "EHLO
        out20-62.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgDLLU1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Apr 2020 07:20:27 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1061301|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0162954-0.00282821-0.980876;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03309;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.HFDh.ST_1586690424;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HFDh.ST_1586690424)
          by smtp.aliyun-inc.com(10.147.41.138);
          Sun, 12 Apr 2020 19:20:24 +0800
Date:   Sun, 12 Apr 2020 19:21:21 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     guaneryu@gmail.com, fstests@vger.kernel.org,
        linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        amir73il@gmail.com
Subject: Re: [PATCH 1/2] common: add a helper for setting module param
Message-ID: <20200412112121.GB3923113@desktop>
References: <20200410012059.27210-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410012059.27210-1-cgxu519@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 10, 2020 at 09:20:58AM +0800, Chengguang Xu wrote:
> Add a new helper _set_fs_module_param for setting
> module param.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

I think this could go with the test, so a single patch introduces both
test case and the needed helper functions, and usually that's easier to
review, as we could know how the helper be used from the context.

Thanks,
Eryu

> ---
>  common/module | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/common/module b/common/module
> index 39e4e793..148e8c8f 100644
> --- a/common/module
> +++ b/common/module
> @@ -81,3 +81,12 @@ _get_fs_module_param()
>  {
>  	cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
>  }
> + # Set the value of a filesystem module parameter
> + # at /sys/module/$FSTYP/parameters/$PARAM
> + #
> + # Usage example:
> + #   _set_fs_module_param param value
> + _set_fs_module_param()
> +{
> +	echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
> +}
> -- 
> 2.20.1
> 
> 
