Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011E54D8CE;
	Sat, 28 Jun 2025 08:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751099855; cv=none; b=FfSVynL/eijaoWPisJyFJm8nJUGItLCGjy5vmhHAbPLn3AH4bHI5oM+vlnX9CHlE3JH/nu+oAHUzu+/gL6nQrK/++7ZFIX4nCbP9s3zy+AvhOy4u1fixDNq6AL3dyMrugQQIrH7ZmdPDiZvZDoUYpcdjcuHnb0ylSvl/WWCZ8Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751099855; c=relaxed/simple;
	bh=ameMdu84bmUnjMcu+SDmeqNZjQWo0+HATdqIfZkFDDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WGE64o9EylPB73fjW6zNPNLbi9e0Vkl5WNNM8YEy7mO0NjBikgCGDQo1FwBm+vNU5AxiMHHLbRKgRkHf4/7Sxdi58V+qxWM2Tb/CWmmEKRdYGV2Rx4mXkkdLjv917D3dhh2cpGOzZVzx3ESyJtnVtgr63bnAJeDbhWjhUOOhhCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id C74E02A7F4A;
	Sat, 28 Jun 2025 10:32:13 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id ruW5vJ1vT0kL; Sat, 28 Jun 2025 10:32:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 7A23F266875;
	Sat, 28 Jun 2025 10:32:13 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oJ0rubv0ZrxV; Sat, 28 Jun 2025 10:32:13 +0200 (CEST)
Received: from nailgun.corp.sigma-star.at (85-127-104-84.dsl.dynamic.surfer.at [85.127.104.84])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 0FEFD28F9EF;
	Sat, 28 Jun 2025 10:32:13 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	corbet@lwn.net,
	amir73il@gmail.com,
	miklos@szeredi.hu,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH] overlayfs.rst: Fix inode table
Date: Sat, 28 Jun 2025 10:32:05 +0200
Message-ID: <20250628083205.1066472-1-richard@nod.at>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The HTML output seems to be correct, but when reading the raw rst file
it's annoying.
So use "|" for table the border.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 Documentation/filesystems/overlayfs.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
index 4133a336486d5..40c127a52eedd 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -61,7 +61,7 @@ Inode properties
 |Configuration | Persistent | Uniform    | st_ino =3D=3D d_ino | d_ino =3D=
=3D i_ino |
 |              | st_ino     | st_dev     |                 | [*]        =
    |
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D+=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+
-|              | dir | !dir | dir | !dir |  dir   +  !dir  |  dir   | !d=
ir  |
+|              | dir | !dir | dir | !dir |  dir   |  !dir  |  dir   | !d=
ir  |
 +--------------+-----+------+-----+------+--------+--------+--------+---=
----+
 | All layers   |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y=
    |
 | on same fs   |     |      |     |      |        |        |        |   =
    |
--=20
2.49.0

