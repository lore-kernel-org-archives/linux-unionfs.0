From: Richard Cochran <richardcochran@gmail.com>
Subject: running binaries under doubly stacked overlayfs
Date: Mon, 19 Sep 2016 21:10:10 +0200
Message-ID: <20160919191010.GC4246@netboy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36280 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcISTKV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Sep 2016 15:10:21 -0400
Received: by mail-wm0-f45.google.com with SMTP id w84so93013141wmg.1
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Sep 2016 12:10:20 -0700 (PDT)
Received: from netboy (188-22-25-8.adsl.highway.telekom.at. [188.22.25.8])
        by smtp.gmail.com with ESMTPSA id r8sm24525773wjs.22.2016.09.19.12.10.18
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Sep 2016 12:10:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org


Using kernel v3.18.41, something unexpected happens when I mount two
overlays.  Once the second overlay is mounted, the binaries won't
execute any more.  Below is a simple script to demonstate the issue.
Although this uses a shell script, the same thing happens with actual
binaries.

What am I doing wrong here?

Thanks,
Richard

---8<---
cd /tmp
mkdir merged layer1 layer2 w1 w2
touch layer1/.layer1 layer2/.layer2
cat > merged/helo.sh <<-EOF
	#!/bin/sh
	echo helo
EOF
chmod +x merged/helo.sh
mount -t overlay overlay \
-oro,lowerdir=/tmp/merged,upperdir=/tmp/layer1,workdir=/tmp/w1 /tmp/merged
./merged/helo.sh
# works as expected
mount -t overlay overlay \
-orw,lowerdir=/tmp/merged,upperdir=/tmp/layer2,workdir=/tmp/w2 /tmp/merged
./merged/helo.sh
# -bash: ./merged/helo.sh: Invalid argument
