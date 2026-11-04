Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817925;
	b=b4DZzCGRthuNMJZ4toJRuavH8YDqajhw+q4UXfOnbLHGV9UAU7EMRnXvm+0DvJeSeea1
	 bRzm1hg4QwJy1tkV+DEVsqTRw+SBIHdLuUSxaCh6LwyidpMQCf0J6Qjs0QDFomJXxBVAs
	 uj2vTG+MqVbHuJybbWtEejZFhkviotYYpYcDccuq2zQ320WmfkI3F3oj34eAkG/aSh/T4
	 J7eIc07Ut48UdZtMX/nL9EY04aF7ZqoS9nX7NDToFXNiFcrHF6i/hWmx8UypcmWzG+ypv
	 Fgwv5B+GsHYmPO8hjsHbM1bkngnTPACsjNNgABatALgXQYdHF6nfjNo1bLVSIUym+/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPw1QwY9l14AppDgzi11II1h1/e89fvFO5BaBQtgmgE=;
	b=rzNGlB6lBy58LpxKIwkNdJdu57kVkUyYUSUTSmm9zUxLMzqIhTN+DKKUOzFwQ/+PHeGn
	 ftwJIgn4WWm0G+4NCwwUn+0sWdZVFHfHi9YJwx4XlTKwoE9djxCtk44CuqEYWB8hIR3pO
	 JPBNw7Wxsxz4e+zpg97BBeIYKXAPGHwXDja/qpDlj45tsMz6gmmfvUQStXUdUiHNSj7KR
	 Jz/vOFq3wdVBB48OOnVyZblvJo6bXbdnYhM15JCPLV0Cxwu6qxtAtjRD9wLu80LVptO+k
	 3K19ZxqbveyZDFsOMm/HmyYEtQA0Ps6ec+PtbyZ26bZPSxp9m5XPNPxZdER6T7nvPNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0DVQoPSi;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE13606A32E
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:45:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EE13606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0DVQoPSi
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a210470b49so8008875e9.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817923; x=1794422723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JPw1QwY9l14AppDgzi11II1h1/e89fvFO5BaBQtgmgE=;
        b=0DVQoPSioNKOoakF7h+BRcrSTXgOfuGcaCzvwo0RBcpnQX258Ph5HSHH8GWsus/ljZ
         9kE4q400T4Wzf+8sn4tt3E3RyUDNInqOlceCJbrLgWQ7H67LdfTiqGH7fHSc+RGx2+vC
         FvHZ0+NFKJz+zfuyG2XgiYMFF4BGGj9MMUvzgXkEkrOQWpipI9z7n8ikNeEV+TugePsn
         s50h2wgMOw6hQux5CTCYWdewO7B0neVZ/YDrDP7e+xipi60xiaiBhkfH/6gQHISTNhcJ
         ZmjGhqTTW3ce/XWcwiBv+kCpR5V5XLZ3Rs4zZAx8adFrt0KhhkMvKrpsrMau/cBjcqtx
         BGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817923; x=1794422723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JPw1QwY9l14AppDgzi11II1h1/e89fvFO5BaBQtgmgE=;
        b=Gs8agdse0rmhpSBU2hBaadTlc5EDTsgBE46IhkQFdbP/mGYIGLhKR25KsBt24V6AkH
         qPMuf3mBn9YU2WFgkjgIl+QeqwINBp2u9aX4sjYMcJofzT1f/qwEpfiuTXhJmy12jRBO
         37bGgrTgT/r5nDTjXZr0H/sYLSCwvhd6XbDnXB5aMQmlKzl2pre7RdF9cmXKBg6A5QFU
         hD8cPHfseboiDr6xDpfMFgdx2M7N2UuopW1egvbxFLvCjptmM6NeVmq0NV2zHgiCwZpI
         0xIx+HWvPESnwFXNRYlJNKcTFPMvOfSf0n9jKo+di6TObzOIB8PP98ItDX3shi+uf66i
         lssA==
X-Forwarded-Encrypted: i=1; AKwUvBzGOSEEtzjsDFp1wBuIo55n7GM6bKILYEF03ArXqdCUcfmtJwfXPhbb2nmFjOTbl4msDwrYIvns+eI3R1zo@vger.kernel.org
X-Gm-Message-State: APuU4Z/44ObILBCKMSGMuYr/bAcJpqgUTnFrS5MM5IOe+59U8VO6W8EY
	04EmGstl44SNkVcGfRTXnnXI5v5sD2erls9f0kOT/W2eu/7e12eGrafV
X-Gm-Gg: AYBFou01k89Ati8ZXAl997wWKrVPMJ+Ldn3W0exrM/Np2SFNn8oTZa6kfejzTbK88dg
	F2p7cqqdIM98XlZnAQjRYzlYW1YJePxwBl1C0M6OidJVSvGCbxJI5RCBPZAKhNywogJ/Q7fa8G+
	uQUOMlAT2zz8wFByzDA/zNxTBLvIFf3tbkB6QKkcS8dAt1MXsIyT9MpIMUuHxEyUJ8o2tBXDlHC
	Dovcaa8vHyrEc2AbgYSgkE3fKXnQw5w0Fj/SIx6eIRyrSXM4jUU94IaIX5GxFHkrdcZnEoK9ycs
	d8pvgJAsyXz+M3N+6Y7+M4RXY3dCxXpcIhxRSJ1oWeMGlLWlg4w2rLu0m4qJhNcvcjJS2WtBlGF
	wJBgbtvaV1AWJQ/94lHduSgdr2jtpjjFPD22el3JLcZE5foCBXBdQL8tR5IfHF8Thh8Dik6JA6N
	8cVgRbPq6rIWNfEzN81wwr2eZjIItNPvfALr/qEUTqOZUq3SWlCsV4ppMr6ldu0VuseQtaslv0i
	LhRKqQb7cguWCw74kXh6nmqjl6mqXB5OvO/wWyVXeMw9y0OMYcOzVUaJ3RFf+VzLJqnAJIOFwUJ
	32mlYzI+8L62GhZlq6Ne4vjvySJsaZ9L6oyXqge2YCx5uWoN2C+IRnMrTzo0alaKPbIz82FSPUf
	7CXtMIFsgaHKz
X-Received: by 2002:a05:600c:4e43:b0:4ab:e27d:e241 with SMTP id 5b1f17b1804b1-4ac180f28f7mr369940825e9.15.1793817923473;
        Wed, 04 Nov 2026 10:45:23 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b57203a98fsm2821325e9.4.2026.11.04.10.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:45:23 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 3/3] ovl: do not copy up a dentry that was removed
Date: Wed,  4 Nov 2026 19:45:16 +0100
Message-ID: <20261104184517.3630089-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104184517.3630089-1-amir73il@gmail.com>
References: <20261104184517.3630089-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mason <mason@kernel.org>

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -831,7 +831,14 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, c->workdir, temp, c->destdir, upper, 0);
 	unlock_rename(c->workdir, c->destdir);
 	dput(upper);
-- 
backport

