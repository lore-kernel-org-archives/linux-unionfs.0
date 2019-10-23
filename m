MIME-Version: 1.0
Date: Wed, 23 Oct 2019 10:08:30 +0200
References: <20191022204453.97058-1-salyzyn@android.com>
	<20191022204453.97058-3-salyzyn@android.com>
In-Reply-To: <20191022204453.97058-3-salyzyn@android.com>
Message-ID: <CAJfpegsCzwXF5fD1oA+XMrPQ7u8URsXRGOOHkB=ON7fLnd_gFQ@mail.gmail.com>
Subject: Re: [PATCH v14 2/5] overlayfs: check CAP_DAC_READ_SEARCH before
 issuing exportfs_decode_fh
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: multipart/alternative; boundary="0000000000002540d005958f6cc6"
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

--0000000000002540d005958f6cc6
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 22, 2019 at 10:46 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Assumption never checked, should fail if the mounter creds are not
> sufficient.

A bit more explanation would be nice.  Like a pointer to the explanation
given in the open_by_handle_at(2) code where this check was presumably
taken from.

Thanks,
Miklos

--0000000000002540d005958f6cc6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Tue, Oct 22, 2019 at 10:46 PM Mark Salyzyn &lt;=
<a href=3D"mailto:salyzyn@android.com">salyzyn@android.com</a>&gt; wrote:<b=
r>&gt;<br>&gt; Assumption never checked, should fail if the mounter creds a=
re not<br>&gt; sufficient.<br><br>A bit more explanation would be nice.=C2=
=A0 Like a pointer to the explanation given in the open_by_handle_at(2) cod=
e where this check was presumably taken from.<br><div><br></div><div>Thanks=
,</div><div>Miklos</div><br></div>

--0000000000002540d005958f6cc6--
