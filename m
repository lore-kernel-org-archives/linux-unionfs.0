Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972310;
	b=uz8tgyCLgdwRroxVg5dY757qGDmc14Lf9DeJ8BZERgwFHUZPihng59m9E4Hw+lIsUvtq
	 Kl3PwQal6Wbncscxme+5rgAsxVJ96zmbfWty9DqvQLqVQp9Vg3wtxWlTx879kJmtXfYal
	 wPmCTECvcuQC/Av4jaR3sWsuJTALzKWmT3z4XZC5k2NNY18oS1yInMRCqD6Gjetid7Gqf
	 FHgTSCQe1UVe/iH75Xk2+qcrT0IoBL4fS4c8puxghlOAjWNojItCb0RAqSp3da8aTLTW+
	 1mf4ofGd5+4vpOU1QGsLQ9YSl1DPfApKVH4EKRTOqLA8tTKAP6qZffZszTj5z7kphCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972310;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MlkRELsEbU/rSkeDdz16dH6fead09d9RayrhAMM7m5k=;
	b=p5/Srsug7YhZ6fy5oXUn2ovwKJCbD09r2s09sAshoU7r79ZXGYXTDwgLbg0an/pomZdO
	 ygmKL9vmU3fT6Cq2Al31ALTuxYIU6sz7gkZ/+La+kCurT+eAQK2P8zju4W7nRBbDAF75V
	 /ihoVdjR+xXFVudpN10LOgEx+Ffb+AHAFXfrG/3IYo/jmj6TsC2psq1qsVvur9s3a8v+z
	 Y8SqqJVnqD0Tw4kX68iiuaEkwOJYDL05RrGPH9E4/H8Ejs71eX9pc7pO5jRihrn89uiw5
	 QRBJiJhaP8crvutPqD+lzhhs7oWO6q+2/UWl6vLHqIcdes1DFcKMDIgB8H9swzcyDOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=DlDCLUCu;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lZPQsP1l;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54F606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C54F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=DlDCLUCu;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lZPQsP1l
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4A1BF7A011B
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 08:38:29 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 06 Nov 2026 08:38:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1793972309; x=1794058709; bh=MlkRELsEbU/rSkeDdz16d
	H6fead09d9RayrhAMM7m5k=; b=DlDCLUCuzS2veduVVTaLXz5SA03N1WdSDPbSX
	afg8uy/tBoZpYFo7Mka721TRSpAATTiAxrriGWXbvhJw1KibwtRgi5MdaZuDIf/D
	RC5tyAJihd71hZR31Sq00rXQLhwZgSS1ksrQiiBU7w9UeDEtKJG3dipWxDCPRnUi
	5P3xrzJyFh/L+7gM6kGboumliD3Y8S9LrkSkZGYyu0Nu0TtJC0M+kkNzqhREsLbr
	gDZWCd9i870EgpxlWIJ29pjSbMJDHyHb3BmcJ8RYrE1BjoxaE72VCm59UZd+Y1gK
	wmacc1kc7KwENyqTcCMZcF3vS7QvZ1QYVi58qOM7ib0nlroVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793972309; x=1794058709; bh=MlkRELsEbU/rSkeDdz16dH6fead09d9Rayr
	hAMM7m5k=; b=lZPQsP1lR/ItJ4cYB+5rS+IsYd6Gm+Kg37OmYVO7frrEQ7Mp6Zq
	SKGtPdLXJkZ64u93NsvYlf6bwCOPQjADHbkfP1REOhTrIK4FfMbLro506XMhPpvV
	o4qnoEFU1yPnl/b/m1XQ7em6JOwXayJqv+ECSFKyE13i8QDLmvJeUlSolg7X8npG
	FXOvE1uAJRITYJHnJH2W2PVHYbIqbija6hcrnaualqwlc+jeaM0up7Q445vOxidB
	Ux5w5DX1UUIiL/CJ8CcN0UWoNILp9KcI3AKrEib8EgnXZnEtwxfriZWU4mn27fmN
	MydfGvfEjWXSAdBqAanzjcu/PzM7xUzivCQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793972309; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:62NBlr4QdcBlsmKtUqtmF3PM8R8EqzwclyzRvTIgNKt92zq
	A2KjX05yViOtoEGeF77lRIM0QC6U9lnQorjuaTdcc7WrXhvFr2VlSyL9rzf7QxqL
	z+7FR9XlQNnsz8gIDsUETtd5GsTG7uZcPqw38DdFHHj7PU8Qe1tLotkaMCCu+/Ts
	OxpiDqwrxayW5IVBYY+1DtzXbl8jw0z/GhATW+WruqwNIyiFA/lFIUdzZPowG4SB
	4EIkX91zUqzaJdfjKJ21whBYdPYAB3Gsb9mWkJXvsNN74AhmYyx+oBwFasbLBXvr
	BV0O2xP55yzRWVHVl7xvBIX8eIzDrb9FyJum5zg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:+8JfTIuoDKNakF3JELjYMoQSBUOG5vsYh3P775qF+/U=:cRID7yjUMn6p0PUwcj4J5K5P2b5onjsLQaW+llExTZY=;
X-ME-Sender: <xms:Vdjtal9qTSizdF0czZgES5A6OZPuOjdRwRIOWoIMiREyEoL46gx4Qg>
    <xme:VdjtahKc7dlPIH-XWNkzRXgo30hwZAE8DYuLLlWSIo32dUUnyH4EUcnSJQIok_1os
    eIx9PXJ3wa3B0TxzPnBh6OV-Wg8CgQWIE3JiVoQK0RzahUwqiOq0Vf_>
X-ME-Received: <xmr:VdjtagaoefXtOuEwRdCSbbnYrIiNfyOR1kSRTjd_KsVzjxAmgCECi0_-u_GehYHZ8-W2FtnnSQiywXCSqfw_HwLbndN_>
X-ME-Proxy-Cause: dmFkZTEoKznHfAL0GvOpDfUqMYzvXpVD0EGBM641yg/Tz3jd0xpz42Y+2NC/40ILkYZWVw
    sLXlqdrblGaYuqOsBh7lOpAx4VMR6NFT5GYX2Ws5l14Ba7Af0B16Em8A5FZxgM4qj/ejmE
    MkyEgnZTf+OWTr8k2BuBNvEKhEiVdFhAURF3lGnALHhwZ3zqzbF282v+DvuKNDcveYrMeS
    VKAbVDq5sBDpEJ9Xl0FB09IgdKXionVoxEYxga7qXWQHj62FdaddSizgdxWOx/rFJvIhjN
    V8rsFvHEndEp5VL0xJj/ARUQNO9XKM5TJdzusRv7OL3F3grLm+3p1QVJgF8BXfABTIMpf7
    Sy4io0lVbDEdwsvZP5w0HJe8XPondlkIp4qCYCwpQZ3+bSIEBkXBrv1q8fA+9lkOdV2TxL
    kdN4XVa8CGlU0973tY9Qa6w0FvOJJWfzO3KoCHP2vCQGUQpiGSLytLaRpgmoO7lTgBJpfy
    D2HqaETOQuYaONn3oynKVXYAQ3nmI7A9i7dJbVlS9145yTr1IQTtMSgcgnUdy4kzLfs6S9
    j+zXGze90TYakGu31sO3y76OhMR/PqZboH56LTtmzMaSNsjPFm4axatbqxcyFeVLjkcIOh
    sfZ4t/LZiOXVvhhSbk/bIDROfETrouycNVv4StgUBMY3wlGeFvjYd5E4vyrg
X-ME-Proxy: <xmx:VdjtajJyFNReyPr93YVNqagn6skYEH3vs-_o8Ht574Pjr00OiH6yvw>
    <xmx:VdjtauAGx7du8ImPTm7oKK0MkjfSPMf8Fyq8hA3-GiSHIGj9WobtVA>
    <xmx:Vdjtaoqu_LDVuCn9Pgi5OwobI0gu0CJrho-2R1xrZM8176FINA_Wig>
    <xmx:VdjtaphWcWGGOf8ZH6haq_yAiT03ggqxQo_Z-XHS_wzryHnvmY31Wg>
    <xmx:VdjtatJQXjfzVmTh4qdzYORqFdhJOVCwT7-fP9QvCZbyEiippH4rNmCR>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 08:38:28 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com
Subject: [PATCH] overlay: do not always clear absolute_redirect
Date: Fri,  6 Nov 2026 14:38:18 +0100
Message-ID: <20261106133823.1087531-1-giuseppe@scrivano.org>
X-Mailer: git-send-email 2.56.0
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

ovl_check_redirect() clears d->absolute_redirect before it checks that
the path element has a redirect xattr.  An element without one, such as
an intermediate directory in a lower layer, then clears the flag set by
the absolute redirect of a metacopy file found in a higher layer.  The
lookup of the data in the data-only layers is not deferred any more and
the lookup fails with -EIO:

  # l2/f: metacopy, redirect "/dir/file"; l1/dir/ exists, no "file"
  mount -t overlay none -o metacopy=on,redirect_dir=on,\
        lowerdir+=l2,lowerdir+=l1,datadir+=data m
  cat m/f   # Input/output error

Set d->absolute_redirect only when a redirect xattr was read.

Fixes: 5436ab0a864e ("ovl: implement lookup in data-only layers")
Link: https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918ee
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
 fs/overlayfs/namei.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ca899fdfaafd..096e342f7e9f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -39,13 +39,12 @@ static int ovl_check_redirect(const struct path *path, struct ovl_lookup_data *d
 	char *buf;
 	struct ovl_fs *ofs = OVL_FS(d->sb);
 
-	d->absolute_redirect = false;
 	buf = ovl_get_redirect_xattr(ofs, path, prelen + strlen(post));
 	if (IS_ERR_OR_NULL(buf))
 		return PTR_ERR(buf);
 
-	if (buf[0] == '/') {
-		d->absolute_redirect = true;
+	d->absolute_redirect = buf[0] == '/';
+	if (d->absolute_redirect) {
 		/*
 		 * One of the ancestor path elements in an absolute path
 		 * lookup in ovl_lookup_layer() could have been opaque and
-- 
2.56.0

