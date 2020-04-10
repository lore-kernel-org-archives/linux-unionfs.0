Return-Path: <SRS0=xMZa=52=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AF8C2BB85
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 01:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C01CA20769
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Apr 2020 01:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="AF6mj61D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgDJBWE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 21:22:04 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21181 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbgDJBWE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 21:22:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1586481706; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=SWScZIf+LcgdLcv7ztzpOW03QJ9B1yzunaGGbxLeiVPggKP2IDH030S4ueED8bznhV8DfJcbsvw8RiwX6SETnEA8atL0FcNuKRGY9hwpqY5c48pItrCa+AG3UQG29DmyfxiHgWVHyGIUPjIGhqO90tyF7Eng1rxqsu9c03t5KSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1586481706; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=3gbSDram2It9esFZojr88su4Yo8IZ0oB3171/SH9HUA=; 
        b=IpMSpQNxHuXi7nOjEcVN9g3suKNVGo+h5a6VwBlNmUECMbJVihXE/PVpW5h1BFi/BdW8/Sww6iUXhdyHzNckU7FxS5ScPTvyM5pJ1P6ifh62h7Oewz45XBghc7nR5ZeWJ8IQwUyFO6YUX6LmTuniyc1G2Nq3huWrLduQTWeWSHw=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1586481706;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=3gbSDram2It9esFZojr88su4Yo8IZ0oB3171/SH9HUA=;
        b=AF6mj61D+uYHQxkixTTIyGV/tAMbZN+AoPnWCvfpRks7X1nRw5Yl0APiHy5zqWUb
        Q22khV+xNIax7HLmXqEnpH/exg5f8XjbMO05n+v+mRciHqK2nZ7DcAGelsua67MFrX0
        3dIXxGZtutWKmDVSv/9wHc3V5cYlOqt2MVdCn+gA=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1586481704304521.0089517140502; Fri, 10 Apr 2020 09:21:44 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     guaneryu@gmail.com
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        miklos@szeredi.hu, amir73il@gmail.com,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200410012059.27210-1-cgxu519@mykernel.net>
Subject: [PATCH 1/2] common: add a helper for setting module param
Date:   Fri, 10 Apr 2020 09:20:58 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add a new helper _set_fs_module_param for setting
module param.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 common/module | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/module b/common/module
index 39e4e793..148e8c8f 100644
--- a/common/module
+++ b/common/module
@@ -81,3 +81,12 @@ _get_fs_module_param()
 {
 =09cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
 }
+ # Set the value of a filesystem module parameter
+ # at /sys/module/$FSTYP/parameters/$PARAM
+ #
+ # Usage example:
+ #   _set_fs_module_param param value
+ _set_fs_module_param()
+{
+=09echo ${2} > /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
+}
--=20
2.20.1


