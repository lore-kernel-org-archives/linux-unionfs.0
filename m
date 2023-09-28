Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CC1CE7AFE
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Sep 2023 04:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjI1EpT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 00:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjI1EpS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 00:45:18 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF01122
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 21:45:15 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4064a0639b6so18815185e9.1
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 21:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695876314; x=1696481114; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AcXbSw9sTgnfH+W7z4t4vq2SV8G0kIJTK37nKEDOZg8=;
        b=Fk9A+J/iNTcG5mmZaxn119zdBOQLgH3bJiCSG58CoPQ6hmHplkqESLxZ6Vdvsz8IT+
         3tpJFpvMrXOQMQ/p9IWLNGJEmvhwCSzUiN309inHaj4FQEAnIhelMCeAju7v22IQdLnj
         92fqaNgLqii/rNOEOv+wxPSyOMUUHN7PkCmG8+sQHPKqC72SEWk9ojW3Wb+JJbXREeSQ
         CCDmPg9xenS3xd+sXGNtnCud+YfdskJTd2R7QcDNPn7+xtUNF8VVHKtMTAmNYzcflv2W
         yKCpdoEughQXDB/OVrFDKBe0suD+ZGw/etpSEqjHAgcNBKkJIqCb04xi+CBumWr8Leyh
         p9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695876314; x=1696481114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcXbSw9sTgnfH+W7z4t4vq2SV8G0kIJTK37nKEDOZg8=;
        b=HPMo2oY/spkah1PmHsO2i9iRBhDO0xrkEFdJb+2vTKqdQQVg3Syzu1pzElKjQkbX4W
         8l64pSB/YaE/t9vOJHtVg6BM/dWqC+xyp0x0OQv+5Gah4HEqgAXO8jwaeuHOdVqEuo67
         +XFWrTVKxBeQ0kQbwFcoxxEzIitoHo/OKSPJHbpWTxWe6yw1GUQBMXoFgJeyytm8ae9z
         tSNskYricPRrmeVIOARmlHDVxV0YKmzd1lLe63ISDUstSegbCDsBU2sMlYBQv+m7IwyH
         wlOmo6LAhY8Xo1hzCEhLc4huOsWqbDGiXgWqedNwZgG2yAsYYC5P1JUsqIOQkhUKeIAh
         xnYw==
X-Gm-Message-State: AOJu0YwW7aasAo34j6ipqqrrhrU6BPpp43ogNGeB//WY44Jv0lQb0Hwf
        cUwvrzoj9EEWy/HilPK51TSIvQ==
X-Google-Smtp-Source: AGHT+IEj2dreycHkxBbNtsaNblGI5+CWZlWjlbetRiCdKoxnqgfqJnEdezRsuB/1ahQnef8LORtuww==
X-Received: by 2002:a05:600c:3b22:b0:406:5301:4320 with SMTP id m34-20020a05600c3b2200b0040653014320mr81206wms.16.1695876313748;
        Wed, 27 Sep 2023 21:45:13 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b0040535648639sm18988603wmn.36.2023.09.27.21.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 21:45:13 -0700 (PDT)
Date:   Thu, 28 Sep 2023 07:45:11 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Su Hui <suhui@nfschina.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ovl: avoid possible NULL dereference
Message-ID: <91ae5901-fae3-42b8-8c82-dc5c2683b4ce@kadam.mountain>
References: <f929f35e-2599-48e4-a77f-f2002bc94482@kadam.mountain>
 <b1a6134d-f976-ed9d-aac0-06f3c93fc1c6@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1a6134d-f976-ed9d-aac0-06f3c93fc1c6@nfschina.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 28, 2023 at 09:12:01AM +0800, Su Hui wrote:
> Got it, I'm so careless that make this wrong patch.

Not at all.  Your patch didn't break anything and this stuff is subtle.
I've done the same thing myself.

regards,
dan carpenter
