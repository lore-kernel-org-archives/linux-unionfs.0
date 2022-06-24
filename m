Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE7DC433EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 24 Jun 2022 01:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiFXBsT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 21:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFXBsS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Jun 2022 21:48:18 -0400
X-Greylist: delayed 126 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 18:48:17 PDT
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0C2E68A;
        Thu, 23 Jun 2022 18:48:17 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id SXS00107;
        Fri, 24 Jun 2022 09:46:07 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201612.home.langchao.com (10.100.2.12) with Microsoft SMTP Server id
 15.1.2308.27; Fri, 24 Jun 2022 09:46:06 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <miklos@szeredi.hu>, <corbet@lwn.net>
CC:     <linux-unionfs@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] media: docs: Modify the section of User xattr
Date:   Thu, 23 Jun 2022 21:46:05 -0400
Message-ID: <20220624014605.2007-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   20226240946072f1b8e7173e573eab90b3df8c2f41691
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Delete duplicate words of "the".

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 Documentation/filesystems/overlayfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 7da6c30ed596..4c76fda07645 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -607,7 +607,7 @@ can be removed.
 User xattr
 ----------
 
-The the "-o userxattr" mount option forces overlayfs to use the
+The "-o userxattr" mount option forces overlayfs to use the
 "user.overlay." xattr namespace instead of "trusted.overlay.".  This is
 useful for unprivileged mounting of overlayfs.
 
-- 
2.27.0

