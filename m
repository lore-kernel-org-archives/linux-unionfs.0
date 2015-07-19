From: Dominik Paulus <lkml@dominik-paulus.de>
Subject: overlayfs: Problems with NFS as lower filesystem
Date: Sun, 19 Jul 2015 23:44:17 +0200
Message-ID: <20150719214417.GA19135@d-paulus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from himalia.dominik-paulus.de ([37.120.173.242]:44061 "EHLO
	himalia.dominik-paulus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbbGSVvD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 19 Jul 2015 17:51:03 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi!

as far as I can see, NFS as lower filesystem should be supported in
latest mainline kernels. I've tried to use overlayfs with the
combination of a r/o NFS (v3 as well as v4 tested) as lower and tmpfs as
(initially empty) upper filesystem, and have some trouble to get it
working.

Mounting the filesystem works fine, and the merged filesystem shows the
contents of the NFS filesystem. However, any open() calls on a file in
the overlayfs filesystem fail with ENXIO.
When replacing the NFS filesystem by a second tmpfs (keeping mount
options and directory structure the same), everything works just as
expected. Apart from "nolock,ro", the NFS is mounted with standard mount
options.

Any bits (e.g. additional requirements on the lower filesystem) that I
am missing? If this is a bug in overlayfs, I suppose it should be easy
to reproduce, I'm currently using latest git head from Linus' kernel
tree (9d37e6679dfddbb5fa605fb2d7ff448f7cd6d038).

Thanks!
Dominik
