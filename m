Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1337F12F5A6
	for <linux-unionfs@vger.kernel.org>; Sun, 26 May 2024 21:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716758622; cv=none; b=TaKcyFazz72bm+tPl6K3qB5dxOsYH2t0PqxdW3uVq68Zz7Qbm6Y8lue1dPjhNpdD3PSbGdAiGjvwpYM8se4cEsVXkHJ/A6HTc6g5HgvfrQ2BsagcMQkFf0hcRgN7Ee6wPjc0xFJgdiYB80JeWBvl1tr7mndaYxUNUuh2nroyhTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716758622; c=relaxed/simple;
	bh=4br1+bsqarhpsUSUDMHnPY9ItAu5sQzF64WsQKB/4Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN2feBtZS7wwH1DUhnSHgS1sZdRAdRioeZIHJp1+bLPDdcReV1RRb356R4w7DA76MJgLBBXSnQjYY4WENOd+8NhNwtAV4B5nxbojTdXoffVt+yxtuQgsmt2D4rNZ0t0D89UZJ6Fx6UA6z7aHDLB8fDHvW25KY5JNR5a2sZ0FU+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=XmjO/I9h; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="XmjO/I9h"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-355080e6ff9so1876299f8f.2
        for <linux-unionfs@vger.kernel.org>; Sun, 26 May 2024 14:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1716758618; x=1717363418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qbk0UNvpsQrSUqN6RzC4hENS9R3C9NfeLNOx5djjey0=;
        b=XmjO/I9haUhiyklbPuZ9WpTglsUZdxk9OmWkuSxY6sNAUOyzp/IR/oUhSthm6XcE3L
         wJmuerQQprftAOKfkl9baTQLYH6T36DkBMkmyNLzzcVNizzheJu/zoe/hqGeLvGM4xFJ
         +cFcNtMMWq1Kj2gQpoXAFFWhodzuiJHLp4gFEOJ35YagajD7/2Ky23oABy5shch5Hkm9
         RxcXrW93bZepY62gWQnbwK4z89bXIhXdoRgtHoM8OICVbw4qnEX+D06h9U6TwFC+OLbD
         fxE7V63w6kBqOWvtS1En49gwNijuIOJEWyzOK8Jbn4eDETFSKXIwNYRkjgPlpgSrCJNd
         ff7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716758618; x=1717363418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qbk0UNvpsQrSUqN6RzC4hENS9R3C9NfeLNOx5djjey0=;
        b=lXSMfCTo4049mMioeb33M3vm2td0MT0egz4+rJ/y1qK12sKXG0/qxL2rXdy+0jNdOQ
         V2hdaaa2oa6ZK2MK91nFIoxScizvZToK+6xLjm7V7WlrIhIxnqRILzLTBtEHBZkudmnw
         LOk4qCfcM/eeUW9ZsOa/5zpEkSAtMbyXqe2dyyQRCBOtJ1DU/dRye6KE74GLNfhUwDF5
         usp49LrTCCfVZHYpsTxXZJVnE0Kvy7lON4y0iQqI2JRdc9TfubcBF4d7Erwyim9N0dDa
         JW6gk4wjsDDJjSPRp7GpN8+dQW9aZ98i6pLa5qEHA+EFXv8F6VFIJoUmQJ8Lfue7eV76
         Z35g==
X-Forwarded-Encrypted: i=1; AJvYcCWHYwY+pYPDEuNrwpsbhzxFrkGiGX11jxLeMUe5gEr27PNG28FFhDQ21D39YFu/A88Xdh59B6a1a4uP3mXGDARrJ3C4AFI8jtjWQ3GP2A==
X-Gm-Message-State: AOJu0YxDB2S3zgJ5eKdJgZO3hKz8+/OKtSO90CLZ04Ttvc2VZBbugt/l
	WOympvXFA4tB7nArWlzDPQ4STo0g8yddTxvVRj+7FZg02WziKBwByiyfJEeQSc4=
X-Google-Smtp-Source: AGHT+IFy5L/fF6HnmYmy15FzQ2I5Aj94AJhD6S8HOgJeCGnH2efGYlzLjxrfvdfR5wJ4GRUcUbR/8g==
X-Received: by 2002:a5d:4e01:0:b0:354:f1de:33eb with SMTP id ffacd0b85a97d-3552f4fd249mr5166115f8f.26.1716758618179;
        Sun, 26 May 2024 14:23:38 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-100.dynamic.mnet-online.de. [62.216.208.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35579d7de1bsm7224197f8f.13.2024.05.26.14.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 May 2024 14:23:37 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: bhe@redhat.com
Cc: amir73il@gmail.com,
	clm@fb.com,
	dhowells@redhat.com,
	dsterba@suse.com,
	dyoung@redhat.com,
	jlayton@kernel.org,
	josef@toxicpanda.com,
	kexec@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	netfs@lists.linux.dev,
	thorsten.blum@toblux.com,
	vgoyal@redhat.com
Subject: [RESEND PATCH 4/4] crash: Remove duplicate included header
Date: Sun, 26 May 2024 23:23:10 +0200
Message-ID: <20240526212309.1586-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <ZjcvKd+n74MFCJtj@MiWiFi-R3L-srv>
References: <ZjcvKd+n74MFCJtj@MiWiFi-R3L-srv>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicate included header file linux/kexec.h

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Acked-by: Baoquan He <bhe@redhat.com>
---
 kernel/crash_reserve.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
index 5b2722a93a48..d3b4cd12bdd1 100644
--- a/kernel/crash_reserve.c
+++ b/kernel/crash_reserve.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
-- 
2.45.1

