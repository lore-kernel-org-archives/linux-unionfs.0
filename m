Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F151DFE37;
	Wed,  4 Sep 2024 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725468888; cv=none; b=CjphY80UplrZv6CAv6iyNJJr5WWEa7sy8bizGlD/WLbv2jXaSjn2Mr2IRVpmpJGwNr0HZJxfToZasPX5seNMaqrUvR2yP0iLm8uPImwDnt9ekcBzwkzG1v405i1kCvIRK2pl+pFZGElTUlB+3ttQZ7mcqfuK+THZrAtuXslmY7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725468888; c=relaxed/simple;
	bh=ZsKTCmsUak/i2DAtDGrQiNcj4LH51AjCKdgTPIlxiBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZWa5Slo399AhK+O6iCfkYWUCELV7fRSoaEG6yrv8wMx58MgSDU7DZSlu8OziRM/zMQYftoduJsKPvYRLqkFFSadlqu+diJuJx45FFYqzRaeGprYBr1EDZ9WAXvv2S2obELVcEc+0Kyx6hQx0scz6O0J7ifRe7BRkC8f5ca08PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0O8hENn; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0O8hENn"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2f3edb2d908so24859181fa.2;
        Wed, 04 Sep 2024 09:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725468885; x=1726073685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfv9Ui5koTE6GIwpQG+le9EM9spL5yZe9v6frpn0NeE=;
        b=a0O8hENn76nOzkyN/O/AZ0jM2OvEVzwbBWnAtbvNXfLKlL4V94G6aMGsy4eUupKsLv
         s8wpNG/+5UegaTbYztpX2b57ITu+zBZRhUo8o18jYt1hLAI6E5+1pn2JZgk3Nlucs1bX
         oXfVQZ8MKuJQ4GfnsWZxl59FFdgxse7s7QQEa6xRPY6ByQtadGUbPrhMFCJAMPvs1DO4
         2F72k+YAp0wZe+jxXrm3vj1JkaHnYfSvOvAJpsXb3eM0xGgYy3Lxp6fcsaUO+XyBrXbn
         DKDGodw+AgT7Zptnx/AfdyDf19CsBNuCiiz9hhSYzy+gu+C/Uda1EP+VrB3bkvg6OOOm
         jqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725468885; x=1726073685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfv9Ui5koTE6GIwpQG+le9EM9spL5yZe9v6frpn0NeE=;
        b=AmGlmfA9UtrqSa3L4kwB84WsAD3/e9iIDAVCgtfCuLTCh/i73l9uPCA6IBxzYK2bCt
         5H2+32o8Uy1jeschHi8XQcRQZjZqY/PmIPiXNanAjoiex3y3zIhil7pirVfyN1Uy/yi2
         bKalu58iPbiGhbjD27nrPGyAX+AByk9iQXxZSPn3H4oIyCbE7+6MHjZlij0BtrIngdxv
         y4OH5cVfXtpY8ia50omAVFqUHQJ/tGSY9N8YO6Up4r3fB22pZhPCkG4Wqw1MACUwPcPD
         nlx1NPx8Qps6ll5g8emLX/zdMvQiwg4v3nkvItrYMxtjodctuJlQX5/pAEDT2eNE/sA8
         cGlA==
X-Forwarded-Encrypted: i=1; AJvYcCVdrDAIho//IbL5CkzrLzw7gisLG/FLvhRqdvZ5DhEkM8dlmkVGckfaQ1o9YL++V86EWx19+46CAGC6WRc2pg==@vger.kernel.org, AJvYcCVoLhVCMGN5blLPJwLBP/TTeUG16z5CSqgmeJiV+1sgesb7stVP6Cj1jpGcecnmbNi+Db3a1GU4Nhk=@vger.kernel.org, AJvYcCXwY62o9RGoMZHf5hzKmEWgCl939Wv5udPQ5cl3ZtUt1XX55I96wPqJnjokaxoV/R5dE6vAZWJSEJWL4/7f@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdg3EM98VIR21U1z33KKBlP9rXFMWdQGV8h/0Qzo+y5TZj8U1y
	P+fBMGy5Hp3hGJycecIfTet/qWUHd7Zs5BJLQdIXslDlcks4OcJG
X-Google-Smtp-Source: AGHT+IG8W5lrO3q3aYCvr07GYUu/bSieVBAcjT0IhhpnT+F3Z7Lsurv+dQQ/4lJlIHcX92OoFsgX4A==
X-Received: by 2002:a2e:a596:0:b0:2ef:2c6a:4929 with SMTP id 38308e7fff4ca-2f64440dc3emr64698921fa.13.1725468883739;
        Wed, 04 Sep 2024 09:54:43 -0700 (PDT)
Received: from localhost.localdomain ([193.0.218.31])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-2f615181d71sm24421101fa.102.2024.09.04.09.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:54:43 -0700 (PDT)
From: Yuriy Belikov <yuriybelikov1@gmail.com>
To: 
Cc: yuriybelikov1@gmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-unionfs@vger.kernel.org (open list:OVERLAY FILESYSTEM),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] Update metacopy section in overlayfs documentation
Date: Wed,  4 Sep 2024 19:54:29 +0300
Message-ID: <20240904165431.13974-1-yuriybelikov1@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <CAOQ4uxiRGcPNsad==MtLFGrrwg_Sv-6g0tNwSVtvoSH+2VR5Lw@mail.gmail.com>
References: <CAOQ4uxiRGcPNsad==MtLFGrrwg_Sv-6g0tNwSVtvoSH+2VR5Lw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- Provide info about trusted.overlay.metacopy extended attribute.
- Minor rephrasing regarding copy-up operation with
  metacopy=on
Signed-off-by: Yuriy Belikov <yuriybelikov1@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 165514401441..e5ad43f4f4d7 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -367,8 +367,11 @@ Metadata only copy up
 
 When the "metacopy" feature is enabled, overlayfs will only copy
 up metadata (as opposed to whole file), when a metadata specific operation
-like chown/chmod is performed. Full file will be copied up later when
-file is opened for WRITE operation.
+like chown/chmod is performed. An upper file in this state is marked with
+"trusted.overlayfs.metacopy" xattr which indicates that the upper file
+contains no data. Full data will be copied up later when file is opened for
+WRITE operation. After the lower file's data is copied up,
+the "trusted.overlayfs.metacopy" xattr is removed from the upper file.
 
 In other words, this is delayed data copy up operation and data is copied
 up when there is a need to actually modify data.
-- 
2.43.5

