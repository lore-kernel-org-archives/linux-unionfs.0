Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D73C47247
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD3F206B8
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VP+ewoYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgEESIf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 14:08:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39214 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgEESIf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 14:08:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045I8Y4m196596;
        Tue, 5 May 2020 18:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RFNw+wufclTm6os8yCUezLhGfCKDQHduwkHk21poH3c=;
 b=VP+ewoYNJbJM9Zi6ernCdBkYHWJnkKcWn5KaPR3/+SjkNcl/sUrWrCJ87sfd0F2/STQQ
 VZWNM97XuC8+HDXHmIKSQCTF8D2nxpI1KRYa+5kN7Msd/ASabmkPuqXUHD0vy9TYeZiX
 TxuT2AoqlaD81aOSF2Vz6pRiPfhvhVtSrMXRn3bUghOmRj6+/TWjlwlO3pl6Ujlq2MMP
 OD2lSCX0e48MA6Ha2CNUXdxmG1LfXG5wZv2MeSs5iUi2ZeT7U+Xqn1Ig69TLloMz4SNe
 NWrZcoB3oHZp+VBPcIPi9H6LpJ4idjspn0p0v76S7U4d3GljQ5YNOHlMaVIWtDx0Z0e9 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tmeb3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 18:08:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045I6hQB144144;
        Tue, 5 May 2020 18:08:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjk0889y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 18:08:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045I8Wu6008707;
        Tue, 5 May 2020 18:08:32 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 11:08:32 -0700
Date:   Tue, 5 May 2020 21:08:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [bug report] ovl: make sure that real fid is 32bit aligned in
 memory
Message-ID: <20200505180825.GG1992@kadam>
References: <20200505135026.GA38935@mwanda>
 <CAOQ4uxj0F9V=FOUANKSATR2E==BoLr6OJMqsJe5QCbOLNR0k0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj0F9V=FOUANKSATR2E==BoLr6OJMqsJe5QCbOLNR0k0A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=858 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=910 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050138
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 05, 2020 at 07:13:20PM +0300, Amir Goldstein wrote:
> > The patch cbe7fba8edfc: "ovl: make sure that real fid is 32bit
> > aligned in memory" from Nov 15, 2019, leads to the following static
> > checker warning:
> >
> >         fs/overlayfs/export.c:791 ovl_fid_to_fh()
> >         warn: check that subtract can't underflow
> >
> > fs/overlayfs/export.c
> >    775  static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
> >    776  {
> >    777          struct ovl_fh *fh;
> >    778
> >    779          /* If on-wire inner fid is aligned - nothing to do */
> >    780          if (fh_type == OVL_FILEID_V1)
> >    781                  return (struct ovl_fh *)fid;
> >    782
> >    783          if (fh_type != OVL_FILEID_V0)
> >    784                  return ERR_PTR(-EINVAL);
> >    785
> >    786          fh = kzalloc(buflen, GFP_KERNEL);
> 
> Doesn't Smatch warn on possible kmalloc(0)?
> That can't be good. Right?

No, no.  Allocating zero bytes is a useful feature.

	size = 0;
	buf = kzalloc(size, GFP_KERNEL);

	for (i = 0; i < size; i++)
		buf[i] = 42;
	memcpy(dest, buf, size);
	copy_to_user(p, dest, size);

That all works.  Neat, huh?

regards,
dan carpenter

