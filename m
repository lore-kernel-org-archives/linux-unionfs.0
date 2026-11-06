Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793971964;
	b=UZMg03keVPfQ6UlRB/KU8Ca39NWEn5xLFROcitRckyjtulaN6B+qBv2adhDW9cNDyjG6
	 Zg90DCii1G6+8dGTBmQiWObBOF2KWI2Sg6mGUJqlEKi4KBIGJPtZ49ApBEf/5OigWFmpF
	 e7h2djSwttzmrTayFH4UxS7hIDQNtdMezVzWKEu4mmY9hWdRJA2gDWzLJa2Lz0qd7700u
	 PCRW1I3fhbuu3I7BvY67Ue2EFguD2ZkzuqiCQIiRv9otu7/KN1+K/CNe31DQofkfqFew6
	 ZsT7QzZUw6WBLwhtP9z7rAHjw3f6aWfwImJnZLfj9pXYb5AlLAGjKc0Wym/9h7Qcgqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971964;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type;
	bh=4OnjOB9pIZJpiJBLXd+qJf9guJHSSas672AnhYNVolI=;
	b=HWekkjuAvmdVYaKGUdUBUMkY2950nK7Brd+POnSyJIUU2ERX1V+Ba+CY5OSJHx7su5NE
	 4eSQL2pY/4sTsUPUWfJ3FzHtkV01psXShT2HrzGeMUJw3SDpobK0udFz0Tb1P69MlOVL/
	 7q15m1xuH68APEzxQntwswdYUIZXOV0R3AA2jl8BZst3iQpIRYs0HiBh8cl7nBRgLjljj
	 VxbJrfN61RjY0L15TNmViFdC2unQgGrGb+qLEe50wtRRvuEUi/pQ0WqqfpYXRltjfuHgq
	 pFwY4xUoREXYgsYAOdH51a4f/NTBBW8maa09fpjSCrFhZUNStIUUzHAf9OZviM/32hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b="Se9hQ/pI";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=PDg5ANs6;
	arc=none smtp.remote-ip=202.12.124.148
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E70606A329
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65E70606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=Se9hQ/pI;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=PDg5ANs6
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 93FEE1D0006D
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 08:32:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Nov 2026 08:32:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1793971962; x=1794058362; bh=4OnjOB9pIZ
	JpiJBLXd+qJf9guJHSSas672AnhYNVolI=; b=Se9hQ/pIjfkkFkPbtwSy0TO7Wk
	COZWalC2Bp+8AZwRTzN5XMXUccnjOM7X0kaMfVgr9Y/6jqrylhN2ODOWFgl0iK/O
	5A1nZ/Sty1H2D9APp3Wu+M6jMcsvcPMLQTP3GrRLq9LkKUOvNvwV6iQwkCqQSqrP
	LKT+ZCqDhj/lr15SECR6MENIpJvHZN/4CLGdqQea5VBNpFLkWokZSYixtE88d/LY
	tPgq5gAA1MFV/gZAlFAJE2Q8Td1088sOg5/dGoCRTM6VTxJGpUPZMG3cqV4eArj2
	SHl3vCKV20dmysMosdkXyW5oqj6fp7nYasjB36ul4KIHyPW9yBGuSe/svCFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793971962; x=1794058362; bh=4OnjOB9pIZJpiJBLXd+qJf9guJHSSas672A
	nhYNVolI=; b=PDg5ANs6fGxHX++dc+qxY9SP1+kro5gw/UBastyYJnO9Pkn9GGL
	59A97qu2qiDxjYGsqfRuDrtMZ6jtUDcADlE5aIheKn85C0fOdeWU5ci9u4mtZNGK
	xgn6JmaCIHLODYJC+EEJvmAUvlBvSGPF47VtXdAuhgH5qaPteL+2KV4c3F4gkQDi
	T2ZppFbabUGuNH7dsoyB6omtLDjbLhKa9fIOVKO1QhsdA0HTDP57Bxgd2KPEzduC
	ANajaLkyACd1bQOcJM1WjxziVrI/ZS1sdvcAa/gryr3i8mLngpNO+WvJvKUUT8D2
	2S6vmlOpSd4LFraCUX3ua9iS5md3Iuj94NA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793971962; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:X7frhbzhmdh3bJX8XnS9h9r2zsAxj7Y8DWLR537FIVCbSTi
	D2Yfr7BJTBFpY63z8fPaqOydLKiQnB5QPP44HWwWwlmaKoKM5AKhCXFHoXdZXbI4
	/vr0n7W7jnnlNePFHlF6BwP9y2zEoUXqsJaKHT/Cq6N9c55UYk9J3uXk7eyJ0CYd
	4y/SO0AOSmWM3ZJdU1r7+h434DVnQQwm7MkEdsE+F5tudvorT/rCdoB4ZUy1RTGk
	AVdQrVPi1XhXcVHsJ1HrXXMBLKrXEstc56bTaK4TOFE+KgSrRIjg7RuWyCC6yOrg
	vUeR7hCOHI1oS9lwqQx3pt7bGHgBubctw/Pi79g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-type,date,feedback-id,from,in-reply-to,message-id,
	mime-version,references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:F/3tCMukqu8KgYc+fDLSLgnyWnUpjNMTUGOwuZ+bvvQ=:4OnjOB9pIZJpiJBLXd+qJf9guJHSSas672AnhYNVolI=;
X-ME-Sender: <xms:-dbtamhXVx7q9tmLarTc-zhiBRQFL2maZ7KOiLQ3uyiOqxE_rlB5WQ>
    <xme:-dbtauBnxopsS5jax3VnHgtAv5c7ocNkjagQLFn2lQwLUSJrNWtqkJDmcgW3X6DYv
    1eFPw3_eHezWyNpar20-YPpOi6sPJg9reTxAeIVEQxGtTBSTvbiTQSX>
X-ME-Received: <xmr:-dbtajGIN8hX5wUx0-n9_pttroP2XI6zIaIWQOVi4dejE8SuSRx60YyZM0iP01FCKb9yBkRZzKzEL84qXo7vsiDs-fzL>
X-ME-Proxy-Cause: dmFkZTGlJNjlgM+lZXDtVL3iSuHlP1xm2ma0nza7ebfdS6I7DWLzjxfrMYORd/DqqxPON2
    0OCVG88S5c2jIzgNA5RQtX/TOBgHZ8K8aQ6M70i0Cqnic2hsYZJdXNr8WoPxKpc5Owovkl
    gHSUUkDxlY9IsjljFVMN0mK2BlagNapziFVpS70l5iaDViuFmVaZwG6F8XeR6I9QmEDNgS
    BNrPLnURu7kJ2EUhz8rPnf3KEEnJBlYL9t0BdmvbLz+ivnJOFJynEoDDKHEwmPlDUMaJ8t
    n+JlBdpopaKQnjy+3/P9GqWI5wWGvn24WF2WzMeWfpbNgoR3uo3vTRQZeFEgR3f6wMwzUg
    IluU69eZSfD2tq35q01snOC8JdMDIhy/auJZImtmBEHEZmCPvG+yVdNoM8hORlWng6u1qG
    c/NV3akLEzXFeR5vhI/YJzOeFjkw9302/XejF5w6qxDdxZ+4I1VaXUrIZ/S4yXWQsHIPlI
    FSiJHNr9AKa7MwHPdP8A3TXfNs+dj7cIOjid7gpy1hGXElhW+naYroRnC7m/IumfoXiO3e
    HZgCdLeLYZW0TplpbxxWfgNhStgNnJXueZNOlBII+S1Al7sqDEV/GJWvNYLgX8W6cuRxGm
    7PnUov3MEWIyWQ/2o9bnNsPko3JkPwF6A7+HdAybcCreS3NxsdWwCdDWQFIw
X-ME-Proxy: <xmx:-dbtauIQTQiUMyNBbo8W-YGrK3qQ0V7xGiMka_sDyxiwwVmWMpAVZQ>
    <xmx:-dbtavlxlP-0YHUo8W8QPxMRMwnXcseqmoFvFCkItj2WihQ1CidaLQ>
    <xmx:-dbtauSKvH47tnfqv8Q2g4rtBexddzJjVGRN44Kw3oSz2gKjoGLunQ>
    <xmx:-dbtapIOK6UL0J7AMFWmMTOjsJOKgX206cvoQdEfm8s1LuWa07Nbug>
    <xmx:-tbtaiOGXmZ6bp9Qk4YPG83JcCzLJFAd65JbF4TXxIfQEvM3b06uEqvj>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 08:32:41 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
  linux-unionfs@vger.kernel.org,  Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH] overlay: always follow metacopy into data-only layers
In-Reply-To: <CAOQ4uxijrkvG7=0M2nwEXW6BBm312Ra1jhq4n5rw_XkcmMattw@mail.gmail.com>
	(Amir Goldstein's message of "Fri, 6 Nov 2026 13:25:35 +0100")
References: <20261105143138.484820-1-giuseppe@scrivano.org>
	<CAOQ4uxhmh7OpoGnNacFedBPm+jUQfDzv1QD4H+jTvb2kAPK=4Q@mail.gmail.com>
	<87tslumh6i.fsf@redhat.com>
	<CAOQ4uxijrkvG7=0M2nwEXW6BBm312Ra1jhq4n5rw_XkcmMattw@mail.gmail.com>
Date: Fri, 06 Nov 2026 14:32:39 +0100
Message-ID: <87o6c2gk5k.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Amir Goldstein <amir73il@gmail.com> writes:

> Giuseppe,
>
> FYI, Sashiko reported an existing bug in following redirects
> to data-only layers:
>
> https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918ee
>
> I assigned it to you because I figured since you are touching this code
> anyway you may be able to reproduce and test the claim in the bug
> and fix it (?).

the fix is simple enough and doesn't create conflicts with what I am
working on, so I will send it separately.

Thanks,
Giuseppe
