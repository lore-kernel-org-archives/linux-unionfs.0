Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2B43ADB9A
	for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255868; cv=none; b=ldDMua8ORImvGNBjRIw3tjI0yZaokEeQ6vq+rtuxzJNj8qlzaHL1H60ny5efIGN6+NuxnI3k9MaIvuJQNxqL1AeexadNOPKbGQmjBhF7yZBh/9RInEEWfdFIhhr9YIke0kyK8/KAXAqKOJgdjI6qIA1sjwRkN/vvZipf95L/Ufw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255868; c=relaxed/simple;
	bh=Drud1aITCIgS9zLpb0Jw3rnTUV1w7110x1Ghz3/vhzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R9m+hDR7sq0rV5I0eASL0qjsvn/o72vtDx7wVqBOmJ00ixR5yVov6TzdV/2Kr+5yxUeHG5kQ5ykpnEnGqokZ1kHfzi2yps7CG9DUb2EFoUXnZEw2WKDX6dDOGryyipY45UQ8AbrkPk2bsa+q5Z4x5qPOWQIhCkHLKN05prJCDkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdfFO59o; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdfFO59o"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c169ae1cb26so342485666b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 09:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792255865; x=1792860665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0mshVP6NJlRfasFPIJ362oVqpM5P4HZf/7dtAIJY1Aw=;
        b=hdfFO59oSCwT6GhlClUhodohE7hxJ1SB6/4/qR7xUcfjSlNszrHDDe9LxIdZ0LGaGJ
         ZMK6M+CWDIa1KEa0iY8ErvUKYXrIufG+GRhHk9KXCR2nqKImCqX2xkEjGB/5+DuQYY+6
         nWNmADD5BMDSW1MOqG01ABo1Qg4gDouVPiavwVu/cOPGt/F9pEMZ/VCUXY2fo8Em4C6a
         4HNcHSoyg/SXwoMbgzkYTyYZmzHJVFNivD9KvtRoVjXt2ucN6gs8r8MeC4Q6J0xjezwS
         k9VMABhG9Y0Jo7GoZCgVeIn9WAKqdp1WkWrNdj7sqPC3BSi2E4D/AE8jVKmGxLW9hWna
         xOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792255865; x=1792860665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0mshVP6NJlRfasFPIJ362oVqpM5P4HZf/7dtAIJY1Aw=;
        b=fcQnuspmyKX1/H4ETTrc4Befh3oINwk0xdYFsDxVt7UcCyRyN51NMYIHICCABw0WuT
         IqBEjIkg7H4dukrh0EeNBBlpowfDjMFH8cqwFF8lF/a6OTU3m72wkn43WUc/bdo654tL
         0TmvCW9mbTu0KPkuQ3qA59roRoKQFW8b4bbWtP/vpRr4J7CHtseIj53/4Tkb36EddTyc
         rmqh9Y5g1rmH/9CM7Pm4eGiQL43MsiwHl89Vx9NmKAh4/9sjb5RxhRz2bvar4k+cvbLh
         XQY1WS5VRdXL0CfnviB3Jq76hH8IRR9z4d6lq7fs/E70wrDH9ZO3Ir1jHgM92dgArdzQ
         Mpcw==
X-Forwarded-Encrypted: i=1; AKwUvBynUWiGI8RUBZM60hElBsZ50s2MmDPbjqnDlYDy4fe9pNSfIb/1kGQP7uK8C7jntOasisY6svnTSFz6fT5a@vger.kernel.org
X-Gm-Message-State: AFq9FYJUo2p8p1DhVzcZpGQNScsv9bujIWKK0AohHAkKdl7efDXIMEou
	vZQodbKGHAY1uXzT4fQ8yYsFzdFLjoqvtvRXHVUJEdS8PAcQKXnZIpoa
X-Gm-Gg: AYBFou2/RnhGSohV9ciNXKeVla1fFQmZbw8lZ5M//9CdzLQt8eBl1BSDk6cpyt0dKlB
	I/5XZhT8yA2R1mtQTtaegLHGh5q8J2+L43QxmeMYh1VZip1ZdNzpcXgxbEnLG2vO6ZxS2ejXA+i
	ZgKVne6RcXZb3gM5w/kyJIjYn1yS+OPs8fp1UNy2SpMizM0mmPwWhHIePcz+fTDaZuShP2syQhA
	MBjBUGWA7SBb2SBwfxV03CEjDPxjPKasclew6yqOUIeniXQX1ahhtBP4HIo9hiDZe041n8lMUHv
	XRMB00dSvGCCX/ejyDH4I3HvzcNF+opNic0809HltC6/gw9jxFnn1qDgY32sVO1FjWd2FCvw9Kk
	5TyLZMWF4fcv27snl+2B0Q+IYemoY3X5/w0dU0DbmfNqgxvsvfNfJMCG/wseU4EAaYnZ5eGhEpE
	ej1hKq3AeuWbC0S1eLulhrCV+IJRRJ5pzFhQq3AajwAVfhxkK+17Wu1TYMv2kVptgbnqVeRWBWY
	Ey35P/rTq1eU73ef5/Tg6Es
X-Received: by 2002:a17:906:99c2:b0:c41:825d:ed8c with SMTP id a640c23a62f3a-c41825dfa20mr232515666b.26.1792255864717;
        Sat, 17 Oct 2026 09:51:04 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c42554cf6cesm58268566b.36.2026.10.17.09.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 09:51:04 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH] selftests/ovl: fix detached layer mountinfo expectations
Date: Sat, 17 Oct 2026 18:51:03 +0200
Message-ID: <20261017165103.2450042-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_layers_via_detached_mount_fds was copied from the attached-fd test
and still looks for /tmp paths. Detached open_tree() layers are recorded
by d_path() as upperdir=/upper, workdir=/work, and lowerdir+=/ and
datadir+=/ for each cloned directory. The test has failed since it was
added.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Link: https://lore.kernel.org/linux-unionfs/20260924112858.51392-2-disgoel@linux.ibm.com
Fixes: ccc829b15d48a ("selftests: add tests for using detached mount with overlayfs")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../filesystems/overlayfs/set_layers_via_fds.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index 7a293544233d7..83bbacb2550f2 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -686,23 +686,23 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 	while (getline(&line, &len, f_mountinfo) != -1) {
 		char *haystack = line;
 
-		if (strstr(haystack, "workdir=/tmp/w"))
+		if (strstr(haystack, "workdir=/work"))
 			layers_found[0] = true;
-		if (strstr(haystack, "upperdir=/tmp/u"))
+		if (strstr(haystack, "upperdir=/upper"))
 			layers_found[1] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l1"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[2] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l2"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[3] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l3"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[4] = true;
-		if (strstr(haystack, "lowerdir+=/tmp/l4"))
+		if (strstr(haystack, "lowerdir+=/"))
 			layers_found[5] = true;
-		if (strstr(haystack, "datadir+=/tmp/d1"))
+		if (strstr(haystack, "datadir+=/"))
 			layers_found[6] = true;
-		if (strstr(haystack, "datadir+=/tmp/d2"))
+		if (strstr(haystack, "datadir+=/"))
 			layers_found[7] = true;
-		if (strstr(haystack, "datadir+=/tmp/d3"))
+		if (strstr(haystack, "datadir+=/"))
 			layers_found[8] = true;
 	}
 	free(line);
-- 
2.55.0

