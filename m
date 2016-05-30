From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v3 00/17] Xattr inode operation removal
Date: Mon, 30 May 2016 20:51:55 +0200
Message-ID: <CA+icZUWUkY7Rj6+K26tAffUtCbySLiCvyD+ZYvoPrJPQO1cO+w@mail.gmail.com>
References: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
	<CA+icZUXGxsw-g1W8QzwuFx=8UTnxzQD9UsNEH2PHCGrqW=0xdA@mail.gmail.com>
	<CAHc6FU6gZHEcrqvyKdKJbFVrd0L8=M2ynm2GD6tQx32fzTjD=g@mail.gmail.com>
	<CA+icZUVmB1pSuG1_3-nkiKjoDH9UrvUEsZjy8hS6_+Y2yDyruA@mail.gmail.com>
	<CA+icZUWVdtqK4OcXhjVDbrqfXBO5-DpbB5nVpX+iTN_RBDH5Xw@mail.gmail.com>
	<CAHc6FU40o3VpzV-oL81NqrYB3Ryt-nCOeEZCfnQSPFZ==cWvDA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <CAHc6FU40o3VpzV-oL81NqrYB3Ryt-nCOeEZCfnQSPFZ==cWvDA@mail.gmail.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

On 5/30/16, Andreas Gruenbacher <agruenba@redhat.com> wrote:
> On Mon, May 30, 2016 at 6:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> I contacted the LTP mailing-list on the acl_test01 issues - WIP.
>>
>> From the LTP-ML I got the impulse to test with the xattr testcase...
>>
>> root# cd /opt/ltp ; LC_ALL=C ./runltp -s xattr | tee xattr.log
>>
>> ...this fails only in the cgroup_xattr testcase.
>> [...]
>
> The test seems to try getting/setting an xattr named "trusted." (no
> suffix). That's an invalid name; such invalid names are rejected since
> commit 98e9cb571 "vfs: Distinguish between full xattr names and proper
> prefixes" (v4.5-rc1).
>
> Could you try removing that from the LTP test and rerun it?
>

AFAICS I need to re-compile...

[ testcases/kernel/controllers/cgroup_xattr/cgroup_xattr.c ]
...
/* only security.* & trusted.* are valid key names */
static struct tst_key tkeys[] = {
        { .name = "security.",          .good = 1,      },
        { .name = "trusted.test",       .good = 1,      },
        { .name = "trusted.",           .good = 1,      }, <--- XXX:
This one only?
        { .name = "user.",              .good = 0,      },
        { .name = "system.",            .good = 0,      },
};
...

Which "trusted." line or lines shall I remove?

- Sedat -
