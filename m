From: Richard Cochran <richardcochran@gmail.com>
Subject: Re: running binaries under doubly stacked overlayfs
Date: Tue, 20 Sep 2016 10:52:08 +0200
Message-ID: <20160920085207.GA8315@netboy>
References: <20160919191010.GC4246@netboy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38449 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754138AbcITIwN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:52:13 -0400
Received: by mail-wm0-f49.google.com with SMTP id l132so22437972wmf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Sep 2016 01:52:13 -0700 (PDT)
Received: from netboy (93-82-120-150.adsl.highway.telekom.at. [93.82.120.150])
        by smtp.gmail.com with ESMTPSA id va3sm27283643wjb.18.2016.09.20.01.52.10
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2016 01:52:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160919191010.GC4246@netboy>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

On Mon, Sep 19, 2016 at 09:10:10PM +0200, Richard Cochran wrote:
> What am I doing wrong here?

To answer my own question, it does working using the lowerdir=a:b
syntax available starting with kernel 4.0.

Thanks,
Richard
