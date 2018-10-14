From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/25] vfs: implement opportunistic short dedupe
Date: Sun, 14 Oct 2018 10:26:04 -0700
Message-ID: <20181014172604.GH30673@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938927786.8361.10345203650384514542.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153938927786.8361.10345203650384514542.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

How is RFR_SHORT_DEDUPE so different from RFR_SAME_DATA + RFR_CAN_SHORTEN
that we need another flag for it?
