Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4F8C77B75
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Apr 2023 02:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDSCJq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 18 Apr 2023 22:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjDSCJo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2023 22:09:44 -0400
Received: from sonic310-31.consmr.mail.ne1.yahoo.com (sonic310-31.consmr.mail.ne1.yahoo.com [66.163.186.212])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81173658E
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Apr 2023 19:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1681870182; bh=BeV4hQ0Xp+8FBWdmFGMRb4ap79c9hxRu3gp0AhZDlhI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=SlXvUpkBUdpU0ETLynJUFTBPLTYTRNjRUA7nc7q3x9EQN2MV4hvq4dkSovNuyTDx9RUT4ApqWEwFKM6FXw1w+Bw5lalhe3qVVFCjn07nqKjmLMyytIv9xMYN8QHO3sjD4ICkh7k9iBg6JbbLMzdOx3TR0MZzNBtQjTsnwqgw1cLBKNpdWd/uWMbKQerPznzfy9Vktu//evETGeIWVQIjFvDLVrOh1faVOKdqDoYTTMtsoEou6UV4ZaPuVJ97lNw3Mdx5EgB2xpLIL7VPFXgVxB8aPURKEITtpTYMV65CeAkD66PhEgrLa8vR43NQo0oKXdrKodlZ1pSISu3ORsl0ew==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1681870182; bh=/iL3qZkFSwKrr9njo5z2Jwd6Gte3/bp4JOgWZcUdjzr=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=QEQCESx+dX+gQKgCtehF9ZK5649lWUFvdK4soylnVhVV3TiHFbXu73KX1N6UUE0Bf4/pMshbIX7cLpxHHRYFXf5xn2e8CWwTglqD/4uoqSsyh5JvL3u8uF0dzz+fQj3y9QQrKlcnATM9OfKuRAmGpV3BzX3WgJee+T6NVU0Cl049qiN7YCHahi1yq5yofVjY6Ez/eZ7WemBmi5LjxcwI5SFtQ/16GK0E70lJ1iBqVxZeHUnoGzAgay5WQQGuTRYMIQIdqcl+H/Sms7BaB5xqG4ZGqsksZGElyV57q9hba1buPJCIrMj3My42baWv1VajKWRfvdcmSS02baZTyrmpXQ==
X-YMail-OSG: n_ukJfYVM1m.22t_4BORtFGiLlUqY1arj08W4sBN3QWDnPlhI1m2DaMqqQVGmrB
 7zLiPkrYBQXPbn1xT2rdZ2r.tjZPNh6u.oh9KXorUkPDfivj7LM6FbYIOAFue.xrbQ8.WZ4ajKYl
 Nz31ZB1BSfCTlP3a9epxGVzX61iD3KcZSOSOuDWU9Hh5obWREccQUf1hmB5IPubTU8yexZcdsHQN
 noCPffyVrjTY2FNm9cK5Gyvo2XRWkigTm8Fb4wh8Eu0BJYAfit7fIR_BAAogQAXA0DWr8C1pkXrZ
 71zo.hwzWwgDe7wflKit8AUivbLz.znwJexNe_UNzx68.It_EthitsJZFfjir28Rda.VSdWdZaGE
 LYQnIDZhhbT6x1Ca7EmtGztMlcuJfnAFu82o4ZEXKGED9LqhpQ4pTfU9dNXQ359A384n.bXYWezt
 6pIPnpOfaeOdSL_nBu8r4u_eliZLtw5DXXgqEk8ej8nxu2rW6bFqbQ0SIrmkjv_qGw07BIQkTJlX
 _con49j35Snbtq_br3zHyExYJXO1RRSvBXfBETiVpaV6nOakTs8J64f0bky8MVxCNjz3dvimOd0u
 o10_sU5ahAityYPTgdZHKYRXs1FtdhdIapGvpVJiGDgMLbNbEhrx1aGMiMzBWPgJmYNyRGK908gL
 aAuic.__RuTXr9ITFLKfy7l5JTLeCs65fdc6h5jS_MFEqQhDW2f5.pEEA2M.BN6bkWwzNi.HMhHe
 AHEm68v6_dBLzUMAFUwL4tbb6Q1xJZBDpN_LgZagzFD6Ef_toUaQ_QztUP6IIh4a_OcQop23eMYL
 wRTGO1oXSVC_yS0.jJFljDmPStM4Imbwj0DJSBPN564knxGssc9hay.GQLhkr7IKj3je02w39a2h
 chFuvJ0PDcbGDp.YKXMmdZKymphSIcNynI4yIkbBXug8hV1McxQzL1tPmrQ8.ces1rqiJ8NtUfdN
 9IqE32rS_NNoIqXD.f4nQEkgwElDhYVrmDFQoqRPq2zxewqlNNgF8qIBDQSKoxwVay_A391e4X3d
 ZdYx9VLTT7SgLIjs8ZT826ErxIaBjykKbgUipV.nPTFyiu3pWw56rfUo_5UmjsEXWl2DEmocqpzH
 sd_h0cUhRe3FfTwIsDTCadjMFen2.u431n7af2Nz80hsH7Qg7PGd_GIHE_wHVfNV68ckffX88flq
 jgvYcH7lfNmbzv4S4Ds6_KcJPHTGt1ozVaRdyJXODjUgEwFHXR5T5le5yU6LQBE.K3SO8Mb0ooqJ
 UaJ3H0XJhcKX2WV1cBrlcNJZsdEC7HnIR28075DjqChUB3xEXVx5_Ai3.KS3rqt3PuFyxG3TsKMV
 gU.mIEK4nlCw8pJ0eT5OIARQnow_h8J8P1owbqUp_5_GME_juXp07t0XqWubf83zHT1Y2XWjb06L
 35OkaooZR3efEuplWTXL7wABqBLhmD2AYXPKsVvGSZ_aHP2Yt5SoJol9DhnRcvdiiIGbxMXdUrpY
 ItJaBp1QzoJ4vAnoYR2NADO0nHHycC0Xm1OW6pGAMZ.nwL.GnJxRXFYQKRrBtPqNBaOxEYNupRzd
 ISqJL2L2dqj_.bDRxFFcXNwNqBW6Wk9pG4CovQSZO7IqqEmgBYoj_eld2b4EwYfCeugJVBlMTGgH
 HvUT10lWB2XFLeEFscA3iXhsPqwsyLKLrxOgGcis3TQIRAIZC4MAJvo7J.fYKH_o4QCBuyM2zh7O
 OJvXuFWm2gcHxpgfbZe9qp4cKR9uyvD8pGHKElUSIaN_mWtAvAm9ERahx2wWrUVok8yv.yyugP0p
 oS8pi31UKwCdvIHKc79bFXHeoXPXZwpICndmjipGCXEkVMzMSAsEhmnopaZRkU4aFJfJk6nb5Oqa
 SAoFk4zNiomDB3dv.PwwzUkwWQONVgvCQ9Ia47oMB5S7FgeZ5d5C3OTaW.bqU1WlO_NYpOB_.e0n
 Cp3s8Hv4i..rjvGOu5_P9mcyipVK1vB1NwJa4wwqfneDnwU2yHPC20LbvXKpVMreMTU5ZdIxtUfB
 lcPVdlCcyNJNGtGX4Bcyfhwd3fXpv8McJ_8onV9_DSVb_SqHCL9YqZ2jlOQxBpvSLmX7FnVK7hb.
 2_D6.FPMHhrFlnB.XNq5W8b4YWGaF1sklcGTv2ftqE5.9tQx0MkomNPCV5Vrb40RSHv1AsN10L4L
 U7wem8qIePPHXuxT2ORkuPi.mBGdN_M4oXwEzipybd4lOoHT2VIuL5ggxDDln.ZoMOuaclEtJwMG
 00hXMVyOYWgYJK1OQdvICnyyGMXsnblk5s_KB1AAjyDjQH_Q.KLqcaRD.b8wPYrDQnFW3kZGZ6IX
 Iho3iZWiwmVqRLDc-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 93d27190-3f9c-44c1-bd73-9ebdd195ddb5
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Wed, 19 Apr 2023 02:09:42 +0000
Received: by hermes--production-bf1-5f9df5c5c4-qlh82 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID dde34e5f596ded5c5100665c917c3abe;
          Wed, 19 Apr 2023 02:09:39 +0000 (UTC)
Message-ID: <7d5c10b6-68da-dea9-b460-1427b17250b5@schaufler-ca.com>
Date:   Tue, 18 Apr 2023 19:09:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Transmute flag is not inheritted on overlay fs
Content-Language: en-US
To:     Mengchi Cheng <mengcc@amazon.com>, miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, kamatam@amazon.com,
        yoonjaeh@amazon.com, Casey Schaufler <casey@schaufler-ca.com>
References: <20230419002338.566487-1-mengcc@amazon.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20230419002338.566487-1-mengcc@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.21365 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 4/18/2023 5:23 PM, Mengchi Cheng wrote:
> Hello,
>
> On the overlay ext4 file system, we found that transmute flag is not
> inherited by newly created sub-directories. The issue can be recreated on
> the newest kernel(6.3.0-rc6) on qemux86-64 with following steps.
>
> /data directory is mounted on /dev/vdb which is a ext4 fs. It is remounted
> as an overlay again to upperdir /home/root/data.
> # mount -t overlay overlay -o lowerdir=/data,upperdir=/home/root/data,workdir=/home/root/data_work /data
> Add a new smack rule and set label and flag to /data directory.
> # echo "_ system rwxatl" > /sys/fs/smackfs/load2
> # chsmack -a "system" /data
> # chsmack -t /data
> Create directories under /data.
> # mkdir -p /data/dir1/dir2
> And then check the smack label of dir1 and dir2.
> # chsmack /data/dir1
> /data/dir1 access="system"
> # chsmack /data/dir1/dir2
> /data/dir1/dir2 access="_"
> We can see dir1 did not inherit transmute flag from data and dir2 got the
> process label.
>
> The transmute xattr of the inode is set inside the smack_d_instantiate
> which depends on SMK_INODE_CHANGED bit of isp->smk_flags. But the bit is
> not set in the overlay fs mkdir function call chain. So one simple solution
> we have is passing inode ptr into smack_dentry_create_files_as and set the
> SMK_INODE_CHANGED bit if parent dir is transmuting. Although it looks
> reasonable to me and we did not meet any issue in testing, I am not sure if
> there is a better solution to it. It will be great, if experts could take
> a look.

I will be happy to look at your solution. Please post a patch.

>
>
> Thanks,
> Mengchi Cheng
>
